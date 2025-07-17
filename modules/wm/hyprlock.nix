{ config, pkgs, userSettings, ... } : 

{
    programs.hyprlock = {
        enable = true;
        settings = {
            background = [
                {
                    monitor = "";
                    path = "/home/jf/.wallpapers/wallpaper_nature_1.png";
                    blur_passes = 1;
                    blur_size = 4;
                    contrast = 0.9;
                    brightness = 0.8;
                }
            ];

            label = [
                # Date
                {
                    monitor = "";
                    text = ''cmd[update:1000] echo $(date +"%Y-%m-%d")'';
                    color = "rgba(242, 243, 244, 0.75)";
                    font_size = 28;
                    font_family = "JetBrains Mono";
                    position = "0, 105";
                    halign = "center";
                    valign = "center";
                }

                # Time
                {
                    monitor = "";
                    text = ''
                        cmd[update:1000] echo "<span>$(date +"%H:%M:%S")</span>"
                    '';
                    color = "rgba(216, 222, 233, 0.70)";
                    font_size = 130;
                    font_family = "JetBrains Mono";
                    position = "0, 240";
                    halign = "center";
                    valign = "center";
                }

                # User name
                {
                    monitor = "";
                    text = "${userSettings.name}";
                    color = "rgba(216, 222, 233, 0.70)";
                    font_size = 24;
                    font_family = "JetBrains Mono";
                    position = "0, -130";
                    halign = "center";
                    valign = "center";
                }

                # Current song
            ];

            # Profile picture
            image = {
                monitor = "";
                path = "/home/jf/.wallpapers/profile.jpg";
                border_color = "0xffdddddd";
                border_size = 0;
                size = 120;
                rounding = -1;
                rotate = 0;
                reload_time = -1;
                position = "0, -20";
                halign = "center";
                valign = "center";
            };


            # Password input
            input-field = {
                monitor = "";
                size = "300,50";
                outline_thickness = 2;
                dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
                dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
                dots_center = true;
                outer_color = "rgba(0,0,0,0)";
                inner_color = "rgba(0, 0, 0, 0.2)";
                font_color = "rgba(200,200,200,0.8)";
                fade_on_empty = false;
                rounding = -1;
                check_color = "rgb(30, 107, 204)";
                placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
                hide_input = false;
                position = "0, -225";
                halign = "center";
                valign = "center";
            };


        };
    };
}
