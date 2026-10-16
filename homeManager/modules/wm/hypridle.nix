{ config, pkgs, lib, ... }:

{
    services.hypridle = {
        enable = true;
        settings = {
            general = {
                lock_cmd               = "pidof hyprlock || hyprlock";
                before_sleep_cmd       = "loginctl lock-session";
                after_sleep_cmd        = "hyprctl dispatch dpms on";
                ignore_dbus_inhibit    = false;
                ignore_systemd_inhibit = false;
                ignore_wayland_inhibit = false;
            };

            listener = [
                {
                    timeout    = 240;
                    on-timeout = ''playerctl -a status 2>/dev/null | grep -q "Playing" || pactl list sink-inputs 2>/dev/null | grep -q "RUNNING" || notify-send "Lock in 1 min"'';
                }
                {
                    timeout    = 300;
                    on-timeout = ''playerctl -a status 2>/dev/null | grep -q "Playing" || pactl list sink-inputs 2>/dev/null | grep -q "RUNNING" || loginctl lock-session'';
                }
            ];
        };
    };
}
