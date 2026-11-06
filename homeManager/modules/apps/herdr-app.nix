{ config, pkgs, lib, inputs, ... }:

let
  appVersion = "0.1.13";
  coreVersion = "0.1.18";

  appSources = {
    "x86_64-linux" = {
      url = "https://releases.herdr.dev/app/${appVersion}/herdr-app-linux-x86_64.tar.gz";
      hash = "sha256-d7C+cqRsoUuzZzZaBBZGQfkUs6aXErrDkdOcVqlZvvQ=";
    };
    "aarch64-linux" = {
      url = "https://releases.herdr.dev/app/${appVersion}/herdr-app-linux-aarch64.tar.gz";
      hash = "sha256-LluwXEfP+60BitNCF+pMgWR21+uEJpL3QHmMkCDwKB4=";
    };
  };

  coreSources = {
    "x86_64-linux" = {
      url = "https://releases.herdr.dev/core/${coreVersion}/herdr-core-linux-x86_64.tar.gz";
      hash = "sha256-Wy+Xy0sqnXprLMWUJiggPtn7t8wMK0sJrYpvVkjiRrc=";
    };
    "aarch64-linux" = {
      url = "https://releases.herdr.dev/core/${coreVersion}/herdr-core-linux-aarch64.tar.gz";
      hash = "sha256-zzM5PPlQu3Y3NNw+FmEKudr4SSORpO8N5WAmzX91KFM=";
    };
  };

  system = pkgs.stdenv.hostPlatform.system;

  herdr-core = pkgs.stdenv.mkDerivation {
    pname = "herdr-core";
    version = coreVersion;

    src = pkgs.fetchurl {
      inherit (coreSources.${system}) url hash;
    };

    dontUnpack = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin herdr-core
      chmod +x $out/bin/herdr-core
      ln -s $out/bin/herdr-core $out/bin/hc
      runHook postInstall
    '';
  };

  herdr-app = pkgs.stdenv.mkDerivation {
    pname = "herdr-app";
    version = appVersion;

    src = pkgs.fetchurl {
      inherit (appSources.${system}) url hash;
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib  # libgcc_s.so.1
      libxkbcommon
      wayland
      vulkan-loader
      fontconfig
      freetype
      libxcb
    ];

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 herdr-app $out/bin/.herdr-app-unwrapped
      install -Dm644 herdr-app.svg \
        $out/share/icons/hicolor/scalable/apps/herdr-app.svg

      mkdir -p $out/share/applications
      cat > $out/share/applications/herdr-app.desktop << EOF
      [Desktop Entry]
      Name=Herdr
      Comment=Desktop app for terminals and coding agents
      Exec=herdr-app
      Icon=herdr-app
      Type=Application
      Categories=Development;
      EOF

      makeWrapper $out/bin/.herdr-app-unwrapped $out/bin/herdr-app \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath (with pkgs; [
          wayland
          vulkan-loader
        ])}

      runHook postInstall
    '';
  };

in {
  home.packages = [
    herdr-app
    herdr-core
  ];
}
