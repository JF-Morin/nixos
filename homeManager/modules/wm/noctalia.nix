{ config, pkgs, inputs, ... }:

let
  noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Deploy the SDDM color template so Noctalia can render it
  home.file.".config/noctalia/templates/sddm-colors.tmpl" = {
    source = ../../../nixos/modules/sddm-theme/noctalia-colors.tmpl;
  };

  # Register the template in Noctalia's config so templates-apply knows about it
  home.file.".config/noctalia/templates.toml".text = ''
    [theme.templates.user.sddm-colors]
    input_path  = "$XDG_CONFIG_HOME/noctalia/templates/sddm-colors.tmpl"
    output_path = "/var/cache/sddm-theme/noctalia-colors.json"
  '';

  # Service: sends templates-apply to the running Noctalia daemon
  systemd.user.services.noctalia-sddm-sync = {
    Unit = {
      Description = "Sync Noctalia theme colors to SDDM";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type       = "oneshot";
      ExecStart  = "${noctalia}/bin/noctalia msg templates-apply";
      # Retry in case the daemon isn't fully up yet
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Path unit: fires whenever Noctalia's settings change (theme switch)
  systemd.user.paths.noctalia-sddm-sync = {
    Unit.Description = "Watch Noctalia settings to auto-sync SDDM theme";
    Path.PathChanged = "%h/.local/state/noctalia/settings.toml";
    Install.WantedBy = [ "default.target" ];
  };
}
