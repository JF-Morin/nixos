{ config, pkgs, userSettings, ... } : 

{
    programs.hyprlock = {
        enable = true;
        settings = {
            background = [
                {
                    monitor = "DP-1";
                    path = "/home/jf/.wallpapers/wallpaper_nature_1.png";
                    blur_passes = 2;
                    contrast = 0.9;
                    brightness = 0.8;
                }
            ];

            label = [
                {
                    monitor = "DP-1";
                    text = "$TIME";
                    color = "rgba(242, 243, 244, 0.75)";
                    font_size = 95;
                    font_family = "JetBrains Mono";
                    position = "0, 300";
                    halign = "center";
                    valign = "center";
                }
            ];

            input-field = {
                monitor = "DP-1";
                size = "300,50";
                outline_thickness = 2;
                dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
                dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
                dots_center = true;
                outer_color = "rgba(0,0,0,0)";
                inner_color = "rgba(0, 0, 0, 0.2)";
                font_color = "rgba(200,200,200,0.5)";
                fade_on_empty = false;
                rounding = -1;
                check_color = "rgb(30, 107, 204)";
                placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
                hide_input = false;
                position = "0, -100";
                halign = "center";
                valign = "center";
            };
        };
    };
}
