{ config, pkgs, lib, sysConfig, ... }:

{
    wayland.windowManager.hyprland = {
        enable = true;
        # HM 26.05 defaults configType to "lua" for stateVersion 26.05, which
        # generates hyprland.lua. Hyprland 0.46+ prefers .lua over .conf when
        # both exist, so our full config in hyprland.conf would be silently ignored.
        # Force "hyprlang" so HM never generates hyprland.lua.
        configType = "hyprlang";
        # Config is managed via xdg.configFile below; UWSM (withUWSM = true)
        # handles session targets, so HM's own systemd wiring is not needed.
        systemd.enable = false;
    };

    xdg.configFile."hypr/hyprland.conf" = {
        force = true;
        text = ''
            ################
            ### MONITORS ###
            ################
            monitor = ${if sysConfig.system.name == "desktop"
                then "DP-1, 3440x1440@75, 0x0, 1, vrr, 0, bitdepth, 10"
                else "eDP-1, 1920x1080@60, 0x0, 1"}


            ###################
            ### MY PROGRAMS ###
            ###################
            $terminal = ghostty
            $fileManager = nautilus
            $launcher = noctalia msg panel-toggle launcher
            $session = noctalia msg panel-toggle session
            $control_center = noctalia msg panel-toggle control-center
            $browser = zen
            $lock = hyprlock
            $script_switch_audio_sink = $HOME/Projects/nixos/scripts/switch_audio_sink.sh


            #################
            ### AUTOSTART ###
            #################
            exec-once = dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
            exec-once = systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
            exec-once = noctalia
            exec-once = hypridle
            exec-once = sleep 3 && noctalia msg templates-apply


            #############################
            ### ENVIRONMENT VARIABLES ###
            #############################
            env = XCURSOR_SIZE,12
            env = HYPRCURSOR_SIZE,12
            env = MOZ_ENABLE_WAYLAND,1


            #####################
            ### LOOK AND FEEL ###
            #####################
            general {
                gaps_in = 4
                gaps_out = 8
                border_size = 0
                resize_on_border = false
                allow_tearing = false
                layout = dwindle
            }

            decoration {
                rounding = 10
                active_opacity = 1.0
                inactive_opacity = 0.8
                shadow {
                    enabled = true
                    range = 4
                    render_power = 3
                    color = rgba(1a1a1aee)
                }
                blur {
                    enabled = true
                    size = 10
                    passes = 3
                    vibrancy = 0.1696
                }
            }

            animations {
                enabled = yes, please :)
                bezier = easeOutQuint,0.23,1,0.32,1
                bezier = easeInOutCubic,0.65,0.05,0.36,1
                bezier = linear,0,0,1,1
                bezier = almostLinear,0.5,0.5,0.75,1.0
                bezier = quick,0.15,0,0.1,1
                animation = global, 1, 10, default
                animation = border, 1, 5.39, easeOutQuint
                animation = windows, 1, 4.79, easeOutQuint
                animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
                animation = windowsOut, 1, 1.49, linear, popin 87%
                animation = fadeIn, 1, 1.73, almostLinear
                animation = fadeOut, 1, 1.46, almostLinear
                animation = fade, 1, 3.03, quick
                animation = layers, 1, 3.81, easeOutQuint
                animation = layersIn, 1, 4, easeOutQuint, fade
                animation = layersOut, 1, 1.5, linear, fade
                animation = fadeLayersIn, 1, 1.79, almostLinear
                animation = fadeLayersOut, 1, 1.39, almostLinear
                animation = workspaces, 1, 1.94, almostLinear, slide
                animation = workspacesIn, 1, 1.21, almostLinear, slide
                animation = workspacesOut, 1, 1.94, almostLinear, slide
            }

            dwindle {
                preserve_split = true
            }

            master {
                new_status = master
            }

            misc {
                force_default_wallpaper = -1
                disable_hyprland_logo = false
            }

            cursor {
                no_hardware_cursors = true
            }


            #############
            ### INPUT ###
            #############
            input {
                kb_layout = us
                kb_variant =
                kb_model =
                kb_options =
                kb_rules =
                follow_mouse = 1
                sensitivity = 0
                touchpad {
                    natural_scroll = true
                }
            }

            device {
                name = epic-mouse-v1
                sensitivity = -0.5
            }


            ###################
            ### KEYBINDINGS ###
            ###################
            $mainMod = SUPER

            bind = $mainMod, ESCAPE, exec, $session
            bind = $mainMod, Q, killactive,
            bind = $mainMod, SPACE, exec, $launcher
            bind = $mainMod, C, exec, $control_center
            bind = $mainMod, B, exec, $browser
            bind = $mainMod, T, exec, $terminal
            bind = $mainMod, H, exec, $terminal -e herdr
            bind = $mainMod, Y, exec, $terminal -e yazi
            bind = $mainMod, E, exec, $fileManager
            bind = $mainMod, F, togglefloating,
            bind = $mainMod, P, pseudo,
            bind = $mainMod, L, exec, $lock

            bind = $mainMod, left, movefocus, l
            bind = $mainMod, right, movefocus, r
            bind = $mainMod, up, movefocus, u
            bind = $mainMod, down, movefocus, d

            bind = $mainMod CTRL, left, movewindow, l
            bind = $mainMod CTRL, right, movewindow, r
            bind = $mainMod CTRL, up, movewindow, u
            bind = $mainMod CTRL, down, movewindow, d
            bind = $mainMod CTRL, h, movewindow, l
            bind = $mainMod CTRL, l, movewindow, r
            bind = $mainMod CTRL, k, movewindow, u
            bind = $mainMod CTRL, j, movewindow, d

            binde = $mainMod ALT, right, resizeactive, 10 0
            binde = $mainMod ALT, left, resizeactive, -10 0
            binde = $mainMod ALT, up, resizeactive, 0 -10
            binde = $mainMod ALT, down, resizeactive, 0 10
            binde = $mainMod ALT, l, resizeactive, 10 0
            binde = $mainMod ALT, h, resizeactive, -10 0
            binde = $mainMod ALT, k, resizeactive, 0 -10
            binde = $mainMod ALT, j, resizeactive, 0 10

            bind = CTRL ALT, left, workspace, -1
            bind = CTRL ALT, right, workspace, +1
            bind = CTRL ALT, h, workspace, -1
            bind = CTRL ALT, l, workspace, +1
            bind = $mainMod, 1, workspace, 1
            bind = $mainMod, 2, workspace, 2
            bind = $mainMod, 3, workspace, 3
            bind = $mainMod, 4, workspace, 4
            bind = $mainMod, 5, workspace, 5
            bind = $mainMod, 6, workspace, 6
            bind = $mainMod, 7, workspace, 7
            bind = $mainMod, 8, workspace, 8
            bind = $mainMod, 9, workspace, 9
            bind = $mainMod, 0, workspace, 10

            bind = $mainMod SHIFT, left, movetoworkspace, -1
            bind = $mainMod SHIFT, right, movetoworkspace, +1
            bind = $mainMod SHIFT, 1, movetoworkspace, 1
            bind = $mainMod SHIFT, 2, movetoworkspace, 2
            bind = $mainMod SHIFT, 3, movetoworkspace, 3
            bind = $mainMod SHIFT, 4, movetoworkspace, 4
            bind = $mainMod SHIFT, 5, movetoworkspace, 5
            bind = $mainMod SHIFT, 6, movetoworkspace, 6
            bind = $mainMod SHIFT, 7, movetoworkspace, 7
            bind = $mainMod SHIFT, 8, movetoworkspace, 8
            bind = $mainMod SHIFT, 9, movetoworkspace, 9
            bind = $mainMod SHIFT, 0, movetoworkspace, 10

            bind = $mainMod, S, togglespecialworkspace, magic
            bind = $mainMod SHIFT, S, movetoworkspace, special:magic

            bind = $mainMod, mouse_down, workspace, e+1
            bind = $mainMod, mouse_up, workspace, e-1

            bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
            bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
            bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

            bindl = , XF86AudioNext, exec, playerctl next
            bindl = , XF86AudioPause, exec, playerctl play-pause
            bindl = , XF86AudioPlay, exec, playerctl play-pause
            bindl = , XF86AudioPrev, exec, playerctl previous

            bindm = $mainMod, mouse:272, movewindow
            bindm = $mainMod, mouse:273, resizewindow

            bind = $mainMod SHIFT, A, exec, $script_switch_audio_sink


            ##############################
            ### WINDOWS AND WORKSPACES ###
            ##############################
            source = ~/.config/hypr/noctalia.conf
        '';
    };
}
