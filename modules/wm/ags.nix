{ inputs, config, pkgs, userSettings, systemSettings, ... } :

{
    imports = [
        inputs.ags.homeManagerModules.default
    ];

    programs.ags = {
        enable = true;

        #configDir = "/home/${userSettings.username}/.config/ags";

        extraPackages = [
            inputs.astal.packages.${pkgs.system}.hyprland
        ];
    };

}
