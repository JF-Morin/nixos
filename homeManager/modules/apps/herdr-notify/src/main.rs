//! Desktop notifications for herdr agents.
//!
//! Follows `hc events` and posts a notification (through Noctalia, over
//! D-Bus) when an agent needs you or finishes, unless the Herdr window is
//! the focused one. Herdr plays its own sound; we only play one when the
//! Herdr window isn't open at all.

use std::collections::HashMap;
use std::env;
use std::io::{BufRead, BufReader};
use std::process::{Command, Stdio};
use std::thread;
use std::time::Duration;

use notify_rust::{Notification, Timeout, Urgency};
use serde::Deserialize;
use serde_json::Value;

const HERDR_CLASS: &str = "herdr-app";

#[derive(Deserialize, Default, Clone)]
struct Status {
    state: String,
    app: Option<String>,
    msg: Option<String>,
    kind: Option<String>,
}

#[derive(Deserialize)]
struct Snapshot {
    address: String,
    #[serde(default)]
    labels: HashMap<String, String>,
    status: Option<Status>,
}

/// One line of `hc events --json`: a snapshot, or a JSON-RPC notification.
#[derive(Deserialize)]
struct Line {
    terminals: Option<Vec<Snapshot>>,
    method: Option<String>,
    params: Option<Params>,
}

#[derive(Deserialize)]
struct Params {
    terminal: Option<String>,
    #[serde(rename = "type")]
    kind: Option<String>,
    #[serde(default)]
    data: Value,
}

#[derive(Deserialize)]
struct LabelsData {
    #[serde(default)]
    labels: HashMap<String, String>,
}

#[derive(Deserialize)]
struct StatusData {
    status: Option<Status>,
}

#[derive(Default)]
struct Terminal {
    state: Option<String>,
    app: Option<String>,
    labels: HashMap<String, String>,
}

impl From<Snapshot> for Terminal {
    fn from(s: Snapshot) -> Self {
        Terminal {
            state: s.status.as_ref().map(|st| st.state.clone()),
            app: s.status.and_then(|st| st.app),
            labels: s.labels,
        }
    }
}

struct Notifier {
    terminals: HashMap<String, Terminal>,
    sounds: Option<String>,
    icon: String,
}

impl Notifier {
    fn on_line(&mut self, line: Line) {
        if let Some(terminals) = line.terminals {
            self.terminals = terminals
                .into_iter()
                .map(|t| (t.address.clone(), t.into()))
                .collect();
            let agents = self.terminals.values().filter(|t| t.state.is_some()).count();
            eprintln!("tracking {} terminals ({agents} agents)", self.terminals.len());
            return;
        }
        // "missed" is followed by a fresh snapshot; "heartbeat" needs nothing.
        if line.method.as_deref() != Some("event") {
            return;
        }
        let Some(params) = line.params else { return };
        let Some(address) = params.terminal else { return };
        match params.kind.as_deref() {
            Some("created") => {
                if let Ok(snap) = serde_json::from_value::<Snapshot>(params.data) {
                    self.terminals.insert(address, snap.into());
                }
            }
            Some("labels") => {
                if let Ok(d) = serde_json::from_value::<LabelsData>(params.data) {
                    self.terminals.entry(address).or_default().labels.extend(d.labels);
                }
            }
            Some("status") => {
                if let Ok(d) = serde_json::from_value::<StatusData>(params.data) {
                    self.on_status(&address, d.status);
                }
            }
            Some("removed" | "finished" | "lost") => {
                self.terminals.remove(&address);
            }
            _ => {}
        }
    }

    fn on_status(&mut self, address: &str, status: Option<Status>) {
        let t = self.terminals.entry(address.to_string()).or_default();
        let prev = t.state.take();
        let state = status.as_ref().map(|s| s.state.clone());
        t.state = state.clone();
        if let Some(app) = status.as_ref().and_then(|s| s.app.clone()) {
            t.app = Some(app);
        }

        // Only terminals Herdr shows in a space (skips hc helpers and tests).
        if !t.labels.contains_key("herdr.space") || state == prev {
            return;
        }
        eprintln!("{address}: {} -> {}", prev.as_deref().unwrap_or("-"), state.as_deref().unwrap_or("-"));
        let status = status.unwrap_or_default();
        let name = agent_name(t.app.as_deref());
        let where_ = t.labels.get("where").cloned().unwrap_or_else(|| address.to_string());
        let body = match status.msg.as_deref() {
            Some(msg) if !msg.is_empty() => format!("{where_}\n{msg}"),
            _ => where_,
        };

        match (status.state.as_str(), prev.as_deref()) {
            ("blocked", _) => {
                let what = match status.kind.as_deref() {
                    Some("permission") => "needs permission",
                    Some("question") => "has a question",
                    Some("auth") => "needs to sign in",
                    _ => "needs you",
                };
                let title = format!("{name} {what}");
                self.notify(address, &title, &body, Urgency::Critical, "dialog-warning.oga");
            }
            ("done" | "idle", Some("working")) => {
                let title = format!("{name} finished");
                self.notify(address, &title, &body, Urgency::Normal, "complete.oga");
            }
            _ => {}
        }
    }

    fn notify(&self, address: &str, title: &str, body: &str, urgency: Urgency, sound: &str) {
        if herdr_focused() {
            return;
        }
        if !herdr_open() {
            self.play(sound);
        }
        let handle = Notification::new()
            .appname("Herdr")
            .summary(title)
            .body(body)
            .icon(&self.icon)
            .urgency(urgency)
            // Noctalia's default is 6 s: easy to miss. Blocked agents wait for
            // you, so their notification stays until dismissed.
            .timeout(match urgency {
                Urgency::Critical => Timeout::Never,
                _ => Timeout::Milliseconds(15_000),
            })
            .action("default", "Open")
            .show();
        let handle = match handle {
            Ok(h) => h,
            Err(e) => return eprintln!("notification failed: {e}"),
        };
        // wait_for_action blocks until the notification is clicked or closed.
        let address = address.to_string();
        thread::spawn(move || {
            handle.wait_for_action(|action| {
                if action == "default" {
                    open_agent(&address);
                }
            });
        });
    }

    fn play(&self, sound: &str) {
        let Some(dir) = &self.sounds else { return };
        let _ = Command::new("pw-play")
            .arg(format!("{dir}/{sound}"))
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn();
    }
}

fn agent_name(app: Option<&str>) -> String {
    match app {
        Some("claude-code") => "Claude".into(),
        Some(app) if !app.is_empty() => {
            let mut c = app.chars();
            c.next().map(|f| f.to_uppercase().chain(c).collect()).unwrap_or_default()
        }
        _ => "Agent".into(),
    }
}

/// `hyprctl` with the running Hyprland instance. The service starts before
/// Hyprland exports HYPRLAND_INSTANCE_SIGNATURE (and Hyprland restarts change
/// it), so pick the newest instance under $XDG_RUNTIME_DIR/hypr each time.
fn hyprctl() -> Command {
    let mut cmd = Command::new("hyprctl");
    let newest = env::var("XDG_RUNTIME_DIR").ok().and_then(|dir| {
        std::fs::read_dir(format!("{dir}/hypr"))
            .ok()?
            .flatten()
            .filter(|e| e.path().join(".socket.sock").exists())
            .max_by_key(|e| e.metadata().and_then(|m| m.modified()).ok())
    });
    if let Some(entry) = newest {
        cmd.arg("--instance").arg(entry.file_name());
    }
    cmd
}

fn hypr(what: &str) -> Value {
    hyprctl()
        .args(["-j", what])
        .output()
        .ok()
        .and_then(|o| serde_json::from_slice(&o.stdout).ok())
        .unwrap_or(Value::Null)
}

fn herdr_focused() -> bool {
    hypr("activewindow")["class"] == HERDR_CLASS
}

fn herdr_open() -> bool {
    hypr("clients")
        .as_array()
        .is_some_and(|cs| cs.iter().any(|c| c["class"] == HERDR_CLASS))
}

fn open_agent(address: &str) {
    let _ = hyprctl()
        .args(["dispatch", "focuswindow", &format!("class:{HERDR_CLASS}")])
        .stdout(Stdio::null())
        .status();
    let args = serde_json::json!({ "terminal": address }).to_string();
    let _ = Command::new("herdr-app")
        .args(["do", "agent.focus", &args])
        .stdout(Stdio::null())
        .status();
}

fn follow(n: &mut Notifier) -> std::io::Result<()> {
    let mut child = Command::new("hc")
        .args(["events", "--json"])
        .stdout(Stdio::piped())
        .spawn()?;
    let stdout = child.stdout.take().expect("piped stdout");
    for line in BufReader::new(stdout).lines() {
        if let Ok(parsed) = serde_json::from_str::<Line>(&line?) {
            n.on_line(parsed);
        }
    }
    eprintln!("hc events exited ({})", child.wait()?);
    Ok(())
}

fn main() {
    let mut n = Notifier {
        terminals: HashMap::new(),
        sounds: env::var("HERDR_NOTIFY_SOUNDS").ok().filter(|s| !s.is_empty()),
        icon: env::var("HERDR_NOTIFY_ICON").unwrap_or_else(|_| HERDR_CLASS.into()),
    };
    loop {
        if let Err(e) = follow(&mut n) {
            eprintln!("hc events failed: {e}");
        }
        thread::sleep(Duration::from_secs(3));
    }
}
