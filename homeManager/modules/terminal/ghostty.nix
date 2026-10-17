{ config, pkgs, lib, ... }:

{
    programs.ghostty = {
        enable = true;
        settings = {
            "shell-integration"          = "zsh";
            "shell-integration-features" = "no-cursor";
            theme                        = "noctalia";
            "font-family"                = "JetBrainsMono Nerd Font";
            "font-size"                  = 12;
            "cursor-style"               = "block";
            "window-decoration"          = true;
            "background-opacity"         = 0.8;
            "background-blur"            = true;
            "window-padding-x"           = 4;
            "window-padding-y"           = 4;
        };
    };

    home.file.".config/ghostty/themes/noctalia".text = ''
        palette = 0=#21252b
        palette = 1=#e27881
        palette = 2=#98c379
        palette = 3=#eac786
        palette = 4=#71b9f4
        palette = 5=#c88bda
        palette = 6=#62bac6
        palette = 7=#c9ccd3
        palette = 8=#282c34
        palette = 9=#e68991
        palette = 10=#a8cc8e
        palette = 11=#edcf97
        palette = 12=#8dc7f6
        palette = 13=#d3a2e2
        palette = 14=#78c4ce
        palette = 15=#e6e6e6
        background = #21252b
        foreground = #e6e6e6
        cursor-color = #78c4ce
        cursor-text = #21252b
        selection-background = #393e47
        selection-foreground = #e6e6e6
    '';
}
