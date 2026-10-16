{ config, pkgs, lib, sysConfig, ... }:

{
    wayland.windowManager.hyprland = {
        enable = true;

        settings = {

            monitor = if sysConfig.system.name == "desktop"
                then [ "DP-1, 3440x1440@75, 0x0, 1, vrr, 0, bitdepth, 10" ]
                else  [ "eDP-1, 1920x1080@60, 0x0, 1" ];

            "$terminal"             = "ghostty";
            "$fileManager"          = "nautilus";
            "$launcher"             = "noctalia msg panel-toggle launcher";
            "$session"              = "noctalia msg panel-toggle session";
            "$control_center"       = "noctalia msg panel-toggle control-center";
            "$browser"              = "zen";
            "$lock"                 = "hyprlock";
            "$script_switch_audio_sink" = "$HOME/Projects/nixos/scripts/switch_audio_sink.sh";

            exec-once = [
                "systemctl --user import-environment PATH WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                "noctalia & hypridle"
            ];

            env = [
                "XCURSOR_SIZE,12"
                "HYPRCURSOR_SIZE,12"
                "MOZ_ENABLE_WAYLAND,1"
            ];

            general = {
                gaps_in        = 4;
                gaps_out       = 8;
                border_size    = 0;
                resize_on_border = false;
                allow_tearing  = false;
                layout         = "dwindle";
            };

            decoration = {
                rounding         = 10;
                active_opacity   = 1.0;
                inactive_opacity = 0.8;
                shadow = {
                    enabled      = true;
                    range        = 4;
                    render_power = 3;
                    color        = "rgba(1a1a1aee)";
                };
                blur = {
                    enabled   = true;
                    size      = 10;
                    passes    = 3;
                    vibrancy  = 0.1696;
                };
            };

            animations = {
                enabled = "yes, please :)";
                bezier = [
                    "easeOutQuint,0.23,1,0.32,1"
                    "easeInOutCubic,0.65,0.05,0.36,1"
                    "linear,0,0,1,1"
                    "almostLinear,0.5,0.5,0.75,1.0"
                    "quick,0.15,0,0.1,1"
                ];
                animation = [
                    "global, 1, 10, default"
                    "border, 1, 5.39, easeOutQuint"
                    "windows, 1, 4.79, easeOutQuint"
                    "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
                    "windowsOut, 1, 1.49, linear, popin 87%"
                    "fadeIn, 1, 1.73, almostLinear"
                    "fadeOut, 1, 1.46, almostLinear"
                    "fade, 1, 3.03, quick"
                    "layers, 1, 3.81, easeOutQuint"
                    "layersIn, 1, 4, easeOutQuint, fade"
                    "layersOut, 1, 1.5, linear, fade"
                    "fadeLayersIn, 1, 1.79, almostLinear"
                    "fadeLayersOut, 1, 1.39, almostLinear"
                    "workspaces, 1, 1.94, almostLinear, slide"
                    "workspacesIn, 1, 1.21, almostLinear, slide"
                    "workspacesOut, 1, 1.94, almostLinear, slide"
                ];
            };

            dwindle = {
                preserve_split = true;
            };

            master = {
                new_status = "master";
            };

            misc = {
                force_default_wallpaper = -1;
                disable_hyprland_logo   = false;
            };

            cursor = {
                no_hardware_cursors = true;
            };

            input = {
                kb_layout  = "us";
                kb_variant = "";
                kb_model   = "";
                kb_options = "";
                kb_rules   = "";
                follow_mouse = 1;
                sensitivity  = 0;
                touchpad = {
                    natural_scroll = true;
                };
            };

            device = {
                name        = "epic-mouse-v1";
                sensitivity = -0.5;
            };

            "$mainMod" = "SUPER";

            bind = [
                "$mainMod, ESCAPE, exec, $session"
                "$mainMod, Q, killactive,"
                "$mainMod, SPACE, exec, $launcher"
                "$mainMod, C, exec, $control_center"
                "$mainMod, B, exec, $browser"
                "$mainMod, T, exec, $terminal"
                "$mainMod, Y, exec, $terminal -e yazi"
                "$mainMod, E, exec, $fileManager"
                "$mainMod, F, togglefloating,"
                "$mainMod, P, pseudo,"
                "$mainMod, L, exec, $lock"
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"
                "$mainMod CTRL, left, movewindow, l"
                "$mainMod CTRL, right, movewindow, r"
                "$mainMod CTRL, up, movewindow, u"
                "$mainMod CTRL, down, movewindow, d"
                "$mainMod CTRL, h, movewindow, l"
                "$mainMod CTRL, l, movewindow, r"
                "$mainMod CTRL, k, movewindow, u"
                "$mainMod CTRL, j, movewindow, d"
                "CTRL ALT, left, workspace, -1"
                "CTRL ALT, right, workspace, +1"
                "CTRL ALT, h, workspace, -1"
                "CTRL ALT, l, workspace, +1"
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"
                "$mainMod SHIFT, left, movetoworkspace, -1"
                "$mainMod SHIFT, right, movetoworkspace, +1"
                "$mainMod SHIFT, 1, movetoworkspace, 1"
                "$mainMod SHIFT, 2, movetoworkspace, 2"
                "$mainMod SHIFT, 3, movetoworkspace, 3"
                "$mainMod SHIFT, 4, movetoworkspace, 4"
                "$mainMod SHIFT, 5, movetoworkspace, 5"
                "$mainMod SHIFT, 6, movetoworkspace, 6"
                "$mainMod SHIFT, 7, movetoworkspace, 7"
                "$mainMod SHIFT, 8, movetoworkspace, 8"
                "$mainMod SHIFT, 9, movetoworkspace, 9"
                "$mainMod SHIFT, 0, movetoworkspace, 10"
                "$mainMod, S, togglespecialworkspace, magic"
                "$mainMod SHIFT, S, movetoworkspace, special:magic"
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"
                "$mainMod SHIFT, A, exec, $script_switch_audio_sink"
            ];

            binde = [
                "$mainMod ALT, right, resizeactive, 10 0"
                "$mainMod ALT, left, resizeactive, -10 0"
                "$mainMod ALT, up, resizeactive, 0 -10"
                "$mainMod ALT, down, resizeactive, 0 10"
                "$mainMod ALT, l, resizeactive, 10 0"
                "$mainMod ALT, h, resizeactive, -10 0"
                "$mainMod ALT, k, resizeactive, 0 -10"
                "$mainMod ALT, j, resizeactive, 0 10"
            ];

            bindel = [
                ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ];

            bindl = [
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPause, exec, playerctl play-pause"
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioPrev, exec, playerctl previous"
            ];

            bindm = [
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
            ];
        };

        extraConfig = ''
            source = ~/.config/hypr/noctalia.conf
        '';
    };
}
