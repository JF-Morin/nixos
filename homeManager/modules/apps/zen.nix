{ config, pkgs, lib, ... }:

let
    profile = ".zen/izfthd55.Default Profile";
    noctaliaCache = "${config.home.homeDirectory}/.cache/noctalia/zen-browser";
in

{
    home.file."${profile}/user.js" = {
        force = true;
        text = ''
            user_pref("devtools.chrome.enabled", true);
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("ui.systemUsesDarkTheme", 1);

            // Hardware acceleration (Wayland)
            user_pref("gfx.webrender.all", true);
            user_pref("media.hardware-video-decoding.force-enabled", true);

            // Lazy tab restore — only load active tab on startup
            user_pref("browser.sessionstore.restore_on_demand", true);
            user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);
        '';
    };

    home.file."${profile}/chrome/userChrome.css" = {
        force = true;
        text = ''@import "${noctaliaCache}/zen-userChrome.css";'';
    };

    home.file."${profile}/chrome/userContent.css" = {
        force = true;
        text = ''@import "${noctaliaCache}/zen-userContent.css";'';
    };
}
