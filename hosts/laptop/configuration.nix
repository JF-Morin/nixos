# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "JF_Laptop"; # Define your hostname.
    #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Enable networking
        networking.networkmanager.enable = true;

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Set your time zone.
#time.timeZone = "Europe/Paris";
    services.automatic-timezoned.enable = true;

# Select internationalisation properties.
    i18n.defaultLocale = "en_CA.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
    };

# Enable the SDDM Display Manager
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    #services.displayManager.sddm.theme = "";

# Enable Hyprlock
    security.pam.services.hyprlock = {};

# Flatpak
    services.flatpak.enable = true;

# Enable CUPS to print documents.
    services.printing.enable = true;

# Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
# If you want to use JACK applications, uncomment this
        jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
    };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# GPU Driver and OpenGL
    hardware.graphics = {
        enable = true;
#         driSupport = true;
#         driSupport32Bit = true;
    };


#    services.xserver.videoDrivers = ["nvidia"];
#
#    hardware.nvidia = {
#        modesetting.enable = true;
#
#        powerManagement.enable = false;
#
#        powerManagement.finegrained = false;
#
#        open = false;
#
#        nvidiaSettings = true;
#
#        package = config.boot.kernelPackages.nvidiaPackages.stable;
#
#    };



#hardware.nvidia.modesetting.enable = true;

#    programs.steam.enable = true;
#programs.steam.gamescopeSession = true;

 #   programs.gamemode.enable = true;

# environment.systemVariables = {
# 	STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
#       	"/home/user/.steam/root/compatibilitytools.d";
# };


# Default shell
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

# Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.jf = {
        isNormalUser = true;
        description = "JF";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
        packages = with pkgs; [

# Applications
            freecad-wayland
                obsidian
                vlc
                gimp-with-plugins
                inkscape-with-extensions
                brave
                discord
                spotify
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
                zsh # Shell
                fastfetch # System info
                zoxide # Smart 'cd' replacement
                eza # Better LS command and Tree command
                ripgrep-all # Ripgrep, with PDF, doc, zip, etc


# Development
                neovim
                vscodium
                docker
                gh #github
                python312
                rustc
                cargo
                go
                zig
                git
                nodejs_20
                bun
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
            nixfmt
            

# Networking
                tailscale # VPN service
                nmap # Network mapping

# Tools
                flatpak
                fzf #fuzzy finder
                unzip
                gzip
                ffmpeg # Image/Video compression, convertion, etc
                htop # Interactive process viewer
                wget
                curl

# Hardware tools
                brightnessctl

# Hyprland
                #ags # Widgets and bar
                #astal.io
                dunst # Notifications
                libnotify # for notifications
                rofi-wayland # app launcher
                waybar # status bar
                wl-clipboard # Clipboard
                hyprlock # Lock screen
                hyprshot # Screenshots
                nautilus # File explorer => test vs thunar
                wlogout
#thunar # test vs dolphin
#xfce.tumbler # for thunar thumbnails
#ffmpegthumbnailer #video thumbnail
                ];
    };

# Install firefox.
    programs.firefox.enable = true;

# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run: $ nix search wget
    environment.systemPackages = with pkgs; [
            dunst
            libnotify
            neovim
            zsh
            ghostty
            rofi-wayland
    ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

services.samba.enable = true;
# Hyprland
    programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
    };
    
    services.hypridle.enable = true;

    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        font-awesome
    ]; 


    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

# List services that you want to enable:

# Enable the OpenSSH daemon.
    services.openssh.enable = true;

# Enable SMB service
    services.gvfs.enable = true;
    services.tailscale.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?

}
