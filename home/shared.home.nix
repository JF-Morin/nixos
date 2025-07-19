{ inputs, config, pkgs, userSettings, systemSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  home.stateVersion = "25.05"; # Please read the comment before changing.

    imports = [
        ../modules/dev
        ../modules/terminal
        ../modules/wm
    ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

        # Ags/Astal
        inputs.astal.packages.${pkgs.system}.io
        #inputs.astal.packages.${pkgs.system}.gjs
        inputs.astal.packages.${pkgs.system}.cava
        inputs.astal.packages.${pkgs.system}.apps
        inputs.astal.packages.${pkgs.system}.auth
        inputs.astal.packages.${pkgs.system}.river
        inputs.astal.packages.${pkgs.system}.mpris
        inputs.astal.packages.${pkgs.system}.greet
        inputs.astal.packages.${pkgs.system}.source
        inputs.astal.packages.${pkgs.system}.astal3
        inputs.astal.packages.${pkgs.system}.astal4
        inputs.astal.packages.${pkgs.system}.notifd
        inputs.astal.packages.${pkgs.system}.network
        inputs.astal.packages.${pkgs.system}.battery
        inputs.astal.packages.${pkgs.system}.hyprland
        inputs.astal.packages.${pkgs.system}.bluetooth
        inputs.astal.packages.${pkgs.system}.wireplumber
        inputs.astal.packages.${pkgs.system}.powerprofiles

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
        whatsapp-for-linux
        firefox

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
        #gh #github
        python312
        rustc
        cargo
        go
        zig
        #git
        nodejs_20
        bun
        gcc # Required for treesitter?
        gnumake # Required for treesitter?
        # LSPs
        bash-language-server
        ccls
        csharp-ls
        docker-language-server
        emmet-language-server
        gopls
        htmx-lsp2
        lemminx
        lua-language-server
        marksman
        nil
        nixd
        nodePackages.vscode-json-languageserver
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

        # Tools for Fusion360
        #wine-wayland
        #winetricks
        #coreutils
        #gawk
        #lsb-release
        #cabextract
        #mesa
        #mesa-demos
        #polkit
        #p7zip
        #samba
        #spacenavd
        #bc
        #mokutil
        #xorg.xrandr
        #virtualglLib
        #gettext

        # Hyprland
        #ags # Widgets and bar
        dunst # Notifications
        #inputs.astal.packages.${systemSettings.system}.default
        libnotify # for notifications
        rofi-wayland # app launcher
        waybar # status bar
        wl-clipboard # Clipboard
        #hyprlock # Lock screen
        hyprshot # Screenshots
        nautilus # File explorer => test vs thunar
        wlogout
        #thunar # test vs dolphin
        #xfce.tumbler # for thunar thumbnails
        #ffmpegthumbnailer #video thumbnail
        
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jf/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
