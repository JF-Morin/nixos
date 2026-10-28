{ pkgs, inputs, sysConfig, ... }:

let
  primaryUser = (builtins.head sysConfig.users).username;
in
{
  services.displayManager.noctalia-greeter = {
    enable  = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      cursor = {
        path = pkgs.adwaita-icon-theme;
        theme = "Adwaita";
        size  = 24;
      };
      keyboard.layout = "us";
    };

    passwordless-sync-users = [ primaryUser ];
  };
}
