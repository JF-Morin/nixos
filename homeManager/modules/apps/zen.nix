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
