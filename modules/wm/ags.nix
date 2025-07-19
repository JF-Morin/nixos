{ inputs, config, pkgs, userSettings, systemSettings, ... } :

{
    imports = [
        inputs.ags.homeManagerModules.default
    ];

    programs.ags = {
        enable = true;

        configDir = ../ags;

        extraPackages = [
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
        ];
    };

}
