{ config, pkgs, inputs, user, sysConfig, ... }:

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
        firefox
        blender
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

        # Terminal
        yazi # Terminal file eplorer
        oh-my-posh # Command line graphic
        lazygit # Git TUI
        #nerdfonts   # Fonts
        font-awesome # Fonts
        ghostty # Terminal
        tmux # Terminal multiplexer
        bat # Like cat, but better
        stow # Link manager
        #zsh # Shell
        fastfetch # System info
        zoxide # Smart 'cd' replacement
        eza # Better LS command and Tree command
        ripgrep-all # Ripgrep, with PDF, doc, zip etc

        # Development
        neovim
        vscodium
        docker
        python314
        python313Packages.pip        
        rustc
        cargo
        go
        zig
        nodejs_26
        bun
        gcc # Required for treesitter?
        gnumake # Required for treesitter?

        # LSPs
        bash-language-server
        ccls
        #csharp-ls
        docker-language-server
        emmet-language-server
        gopls
        htmx-lsp
        lemminx
        lua-language-server
        #marksman
        nil
        nixd
        vscode-json-languageserver
        sqls
        svelte-language-server
        tailwindcss-language-server
        typescript-language-server
        vscode-extensions.rust-lang.rust-analyzer
        yaml-language-server
        zls
        # Formatter
        nixfmt-classic


        # Networking
        tailscale # VPN service
        nmap # Network mapping
        protonvpn-gui # Proton VPN

        # Tools
        flatpak
        fzf #fuzzy finder
        unzip
        gzip
        ffmpeg # Image/Video compression, convertion, etc
        btop # Interactive process viewer
        wget
        curl
        imagemagick
        webp-pixbuf-loader

        # Hyprland
        dunst # Notifications
        libnotify # for notifications
        rofi # app launcher
        waybar # status bar
        wl-clipboard # Clipboard
        hyprshot # Screenshots
        nautilus # File explorer => test vs thunar
        wlogout
        pavucontrol

        # Quickshell and dependencies
        (inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.withModules [
            pkgs.qt6.qtsvg
            pkgs.qt6.qtimageformats
            pkgs.qt6.qtmultimedia
            pkgs.qt6.qt5compat
        ])


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

    gtk.enable = true;
    stylix.targets.gtk.enable = true;

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
