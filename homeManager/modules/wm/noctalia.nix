{ config, pkgs, inputs, ... }:

let
  noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Deploy custom palettes
  home.file.".config/noctalia/palettes/Nord.json" = {
    source = ./noctalia-palettes/Nord.json;
  };

  # Deploy Noctalia color templates
  home.file.".config/noctalia/templates/neovim.tmpl" = {
    source = ./noctalia-templates/neovim.tmpl;
  };

  # Register templates in Noctalia's config so templates-apply knows about them
  home.file.".config/noctalia/templates.toml".text = ''
    [theme.templates.user.neovim]
    input_path  = "$XDG_CONFIG_HOME/noctalia/templates/neovim.tmpl"
    output_path = "$XDG_CONFIG_HOME/nvim/lua/matugen.lua"
  '';

  # Service: applies all templates and syncs greeter when Noctalia theme changes
  systemd.user.services.noctalia-theme-sync = {
    Unit = {
      Description = "Apply Noctalia templates and sync greeter on theme change";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type       = "oneshot";
      ExecStart  = "${noctalia}/bin/noctalia msg templates-apply";
      ExecStartPost = "${noctalia}/bin/noctalia msg greeter-sync";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Path unit: fires whenever Noctalia's settings change (theme/palette switch)
  systemd.user.paths.noctalia-theme-sync = {
    Unit.Description = "Watch Noctalia settings for theme changes";
    Path.PathChanged = "%h/.local/state/noctalia/settings.toml";
    Install.WantedBy = [ "default.target" ];
  };

  # Service: sends SIGUSR1 to running Neovim instances after matugen.lua is updated
  systemd.user.services.noctalia-neovim-sync = {
    Unit.Description = "Reload Neovim colors after Noctalia updates matugen.lua";
    Service = {
      Type      = "oneshot";
      ExecStart = "${pkgs.procps}/bin/pkill -SIGUSR1 nvim";
      SuccessExitStatus = [ 0 1 ];
    };
  };

  # Path unit: fires when Noctalia writes a new matugen.lua
  systemd.user.paths.noctalia-neovim-sync = {
    Unit.Description = "Watch matugen.lua for Noctalia color updates";
    Path.PathChanged = "%h/.config/nvim/lua/matugen.lua";
    Install.WantedBy = [ "default.target" ];
  };

  # Audio Switcher plugin
  home.file.".local/share/noctalia/plugins/jf/audio-switcher/plugin.toml".source =
    ./noctalia-plugins/audio-switcher/plugin.toml;
  home.file.".local/share/noctalia/plugins/jf/audio-switcher/panel.luau".source =
    ./noctalia-plugins/audio-switcher/panel.luau;
}
