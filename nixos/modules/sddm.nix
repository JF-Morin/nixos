{ config, pkgs, lib, sysConfig, ... }:

let
  c            = config.lib.stylix.colors;
  primaryUser  = (builtins.head sysConfig.users).username;

  themePackage = pkgs.stdenv.mkDerivation {
    name = "sddm-qylock-custom";
    src  = ./sddm-theme;

    dontConfigure = true;
    dontBuild     = true;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/qylock-custom
      cp -r . $out/share/sddm/themes/qylock-custom/

      # Substitute Stylix / base16 color placeholders
      substituteInPlace $out/share/sddm/themes/qylock-custom/Main.qml \
        --replace "@BASE00@" "#${c.base00}" \
        --replace "@BASE01@" "#${c.base01}" \
        --replace "@BASE02@" "#${c.base02}" \
        --replace "@BASE03@" "#${c.base03}" \
        --replace "@BASE04@" "#${c.base04}" \
        --replace "@BASE05@" "#${c.base05}" \
        --replace "@BASE06@" "#${c.base06}" \
        --replace "@BASE07@" "#${c.base07}" \
        --replace "@BASE08@" "#${c.base08}" \
        --replace "@BASE09@" "#${c.base09}" \
        --replace "@BASE0A@" "#${c.base0A}" \
        --replace "@BASE0B@" "#${c.base0B}" \
        --replace "@BASE0C@" "#${c.base0C}" \
        --replace "@BASE0D@" "#${c.base0D}" \
        --replace "@BASE0E@" "#${c.base0E}" \
        --replace "@BASE0F@" "#${c.base0F}"

      substituteInPlace $out/share/sddm/themes/qylock-custom/theme.conf \
        --replace "@BASE00@" "#${c.base00}"
    '';
  };
in
{
  # Runtime color cache dir: writable by the primary user, readable by sddm
  systemd.tmpfiles.rules = [
    "d /var/cache/sddm-theme 0755 ${primaryUser} users -"
  ];

  # These env vars must be set on the display-manager service itself (not in
  # sessionVariables, which only apply after login).
  # GPU-specific vars (GBM_BACKEND, __GLX_VENDOR_LIBRARY_NAME, etc.) are
  # added by each host's gpu module; this block holds the generic ones.
  systemd.services.display-manager.environment = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";
    # NixOS stores icons under /run/current-system/sw — not the FHS default.
    # Without this, SDDM's KWin compositor cannot locate the cursor theme.
    XCURSOR_PATH  = "/run/current-system/sw/share/icons";

    # Allow Main.qml to load the runtime Noctalia colour-override file.
    QML_XHR_ALLOW_FILE_READ = "1";
  };

  services.displayManager.sddm = {
    enable  = true;
    wayland = {
      enable     = true;
      # KWin handles NVIDIA cursor rendering correctly on Wayland.
      # Weston (the default) renders no cursor on NVIDIA.
      compositor = "kwin";
    };
    theme   = lib.mkForce "qylock-custom";

    settings = {
      Theme = {
        CursorTheme = "Adwaita";
        CursorSize  = "24";
      };
    };

    extraPackages = with pkgs; [
      adwaita-icon-theme       # cursor theme used at login
      kdePackages.kwin         # Wayland compositor for the greeter
      qt6.qt5compat            # Qt5Compat.GraphicalEffects (DropShadow, RadialGradient)
      qt6.qtmultimedia         # MediaPlayer + VideoOutput
      qt6.qtsvg                # SVG support
    ];
  };

  # ThemeDir points to /run/current-system/sw/share/sddm/themes/, so the theme
  # package must be in systemPackages to get linked there (extraPackages alone
  # is only for Qt/QML runtime modules, not the theme discovery path).
  # adwaita-icon-theme must also be here so its cursors land in
  # /run/current-system/sw/share/icons/ — that path is on the default XCURSOR
  # search path, whereas extraPackages is only a Qt plugin path and SDDM
  # cannot find the cursor files from there.
  environment.systemPackages = [ themePackage pkgs.adwaita-icon-theme ];
}
