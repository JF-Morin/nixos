{ config, pkgs, ... }: 

{
    # Import theme  
    environment.systemPackages = [
        pkgs.sddm-sugar-dark
        # Required library for sugar dark
        pkgs.libsForQt5.qt5.qtgraphicaleffects
        pkgs.libsForQt5.qt5.qtquickcontrols2
        pkgs.libsForQt5.qt5.qtsvg
    ];

    # Enable the SDDM display manager
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "sugar-dark";
        extraPackages = [
            pkgs.sddm-sugar-dark
        ];
    };

}
