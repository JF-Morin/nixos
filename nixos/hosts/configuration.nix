{ config, pkgs, sysConfig, ... }:

{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configurations/${sysConfig.system.name}.hardware-configuration.nix
        ../modules
    ];

    #####################################################
    # Create users from the settings.users
    #####################################################
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    users.users = builtins.listToAttrs (map (user: {
        name = user.username;
        value = {
            isNormalUser = user.isNormalUser;
            description = user.description;
            extraGroups = [ "networkmanager" ] ++ (if user.isAdmin then [ "wheel" ] else []);
            shell = pkgs.${user.defaultShell};
        };
    }) sysConfig.users);


    #####################################################
    # Create SMB shares for all users
    #####################################################
    services.samba.enable = true;

    # Create all necessary secrets file
    environment.etc = builtins.listToAttrs (map (user: {
        name = "nixos/smb-secrets-${user.username}";
        value = {
            text = ''
        # Credentials for ${user.username}
        username=YOUR_SMB_USERNAME
        password=YOUR_SMB_PASSWORD
            '';
            mode = "0755";
            user = "root";
            group = "root";
        };
    }) sysConfig.users);

    # Create all necessary parent folder (nasty)
    systemd.tmpfiles.rules = [] ++ (builtins.concatMap (user: [
        # Create parent folder for shares in NASTY
        "d /home/${user.username}/nasty 0755 ${user.username} users -"
        
    ] ++ (map (share: 
            # Create a dedicated local folder for every share in the descriptions
            "d /home/${user.username}/nasty/${share.name} 0755 ${user.username} users -"
        ) sysConfig.shares)
    ) sysConfig.users);

    # Create all mount folders with the user's credentials
    fileSystems = builtins.listToAttrs (builtins.concatMap (user:
        let
          userUID = toString config.users.users.${user.username}.uid;
          userGID = toString config.users.users.${user.username}.group;
        in 
        map (share:{
            name = "/home/${user.username}/nasty/${share.name}";
            value = {
                device = "//${share.address}/${share.name}";
                fsType = "cifs";
                options = [
                    "credentials=/etc/nixos/smb-secrets-${user.username}"
                    "x-systemd.automount"
                    "noauto"
                    "x-systemd.idle-timeout=60"
                    "uid=${userUID}"
                    "gid=${userGID}"
                    "file_mode=0700"
                    "dir_mode=0700"
                    "iocharset=utf8"
                    "vers=3.0"
                ];
            };
        }) sysConfig.shares
    ) sysConfig.users);


    #####################################################
    # Apply default style TODO: make it dynamic later
    #####################################################
    stylix = {
        enable = true;
        autoEnable = true;
        image = ../../assets/wallpapers/wallpaper-1.png;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        targets.gtk.enable = true;
        targets.gnome.enable = true;

    };

    programs.dconf.enable = true;




    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "JF-"+"${sysConfig.system.name}"; # Define your hostname.
    #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Enable networking
    networking.networkmanager.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];


    # Enable Hyprlock
    #security.pam.services.hyprlock = {};

    # Flatpak
    services.flatpak.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;



    # GPU Driver and OpenGL
    hardware.graphics = {
        enable = true;
        #         driSupport = true;
        #         driSupport32Bit = true;
    };


    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;

        powerManagement.finegrained = false;

        open = false;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;

    };



    #hardware.nvidia.modesetting.enable = true;

    programs.steam.enable = true;
    #programs.steam.gamescopeSession = true;

    programs.gamemode.enable = true;

    # Space mouse
    hardware.spacenavd.enable = true;

    # List packages installed in system profile. To search, run: $ nix search wget
    #environment.systemPackages = with pkgs; [
    #];

    

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


    environment =  {
        systemPackages = [
            pkgs.cifs-utils
        ];    

        sessionVariables = {
            WLR_NO_HARDWARE_CURSORS = "1";
            NIXOS_OZONE_WL = "1"; # Forces Electron/Chronium apps to use Wayland natively
            MOZ_ENABLE_WAYLAND = "1"; # Force Firefox to use Wayland natively
        };
    };

    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
        ];
        config = {
            common = {
                default = [ "gtk" ];
            };
            hyprland = {
                default = [ "hyprland" "gtk" ];
                "org.freedesktop.impl.portal.Inhibit" = ["hyprland"];
            };
        };
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable SMB service
    services.gvfs.enable = true;
    services.tailscale.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?

}
