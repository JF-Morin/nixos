{ config, pkgs,nixpkgs-unstable, inputs, user, sysConfig, ... }:
let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};

in 

{
    #################################################
    # Set username, home directory and version
    #################################################
    home.username = user.username;
    home.homeDirectory = "/home/" + user.username;
    home.stateVersion = "26.05"; # Please read the comment before changing.


    #################################################
    # Import modules
    #################################################
    imports = [
        ./modules/dev
        ./modules/terminal
        ./modules/wm
        ./modules/apps
    ];

    #################################################
    # Add packages
    #################################################
    # Base packages
    home.packages = with pkgs; [
        # Applications
        obsidian
        vlc
        gimp-with-plugins
        inkscape-with-extensions
        brave
        discord
        spotify
        steam
        libreoffice
        kicad
        #firefox
        blender
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        # Terminal
        yazi # Terminal file eplorer
        lazygit # Git TUI
        #nerdfonts   # Fonts
        font-awesome # Fonts
        pkgs-unstable.herdr
        bat # Like cat, but better
        #zsh # Shell
        fastfetch # System info
        zoxide # Smart 'cd' replacement
        ripgrep-all # Ripgrep, with PDF, doc, zip etc

        # Networking
        tailscale # VPN service
        nmap # Network mapping
        proton-vpn # Proton VPN

        # Tools
        flatpak
        fzf #fuzzy finder
        unzip
        gzip
        ffmpeg # Image/Video compression, convertion, etc
        btop # Interactive process viewer
        wget
        curl
        glow # Terminal markdown viewer
        imagemagick
        webp-pixbuf-loader

        # AI tool's
        claude-code

        # Hyprland
        libnotify # for notifications (notify-send)
        nautilus # File explorer
        pavucontrol

        # Noctalia
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default


    ]
        # Packages for "desktop"
        ++ pkgs.lib.optionals (sysConfig.system.name == "desktop")[
            freecad-wayland
        ]
        # Packages for "laptop"
        ++ pkgs.lib.optionals (sysConfig.system.name == "laptop")[
            brightnessctl
        ];

    qt = {
        enable = true;
    };

    gtk = {
        enable = true;
        theme = {
            name    = "adw-gtk3";
            package = pkgs.adw-gtk3;
        };
        font = {
            name = "JetBrainsMono Nerd Font Mono";
            size = 12;
        };
    };

    # Delegate GTK color variables entirely to Noctalia's dynamic noctalia.css
    xdg.configFile."gtk-3.0/gtk.css" = {
        force = true;
        text  = ''@import url("noctalia.css");'';
    };
    xdg.configFile."gtk-4.0/gtk.css" = {
        force = true;
        text  = ''@import url("noctalia.css");'';
    };

    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            # Web / Http
            "text/html" = "zen.desktop";
            "x-scheme-handler/http" = "zen.desktop";
            "x-scheme-handler/https" = "zen.desktop";
            "x-scheme-handler/about" = "zen.desktop";
            "x-scheme-handler/unknown" = "zen.desktop";

            # PDFs
            "application/pdf" = "zen.desktop";

            # Image files   
            "image/png" = "zen.desktop";
            "image/jpeg" = "zen.desktop";
            "image/webp" = "zen.desktop";
            "image/gif" = "zen.desktop";
            "image/svg+xml" = "zen.desktop";
            "image/avif" = "zen.desktop";
        };
    };


    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
        # ".screenrc".source = dotfiles/screenrc;
    };

    home.sessionVariables = {
        # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
