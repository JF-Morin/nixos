# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemSettings, userSettings, shareDescriptions, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ../../../users/jf.nix
            ../../modules
        ];

    stylix = {
        enable = true;
        autoEnable = true;
        image = .../../../assets/wallpapers/wallpaper-1.png;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        targets.gtk.enable = true;
        targets.gnome.enable = true;

    };

    programs.dconf.enable = true;




    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = userSettings.name + "Desktop"; # Define your hostname.
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

    # SMB shares
    services.samba.enable = true;
    systemd.tmpfiles.rules = [
        # Create the global secrets file if missing
        "f /etc/nixos/smb-secrets 0600 root root - # Change these values!\nusername=YOUR_USERNAME\password=YOUR_PASSWORD\n"

        # Create parent folder for shares in NASTY
        "d /home/${userSettings.username}/nasty 0755 ${userSettings.username} users -"
    ] ++ (map ( share:
            # Create a dedicated local folder for every share in the descriptions
            "d /home/${userSettings.username}/nasty/${share.name} 0755 ${userSettings.username} users -"
    ) shareDescriptions);

    fileSystems = builtins.listToAttrs (map (share: {
        name = "/home/${userSettings.username}/nasty/${share.name}";
        value = {
            device = "//${share.address}/${share.name}";
            fsType = "cifs";
            options = [
                "credentials=/etc/nixos/smb-secrets"
                "x-systemd.automount"
                "noauto"
                "x-systemd.idle-timeout=60"
                "uid=1000"
                "gid=1000"
                "file_mode=0755"
                "dir_mode=0755"
                "iocharset=utf8"
                "vers=3.0"
            ];
        };
    }) shareDescriptions );
    

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
