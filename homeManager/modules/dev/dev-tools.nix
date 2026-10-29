{ pkgs, ... }:

{
    home.packages = with pkgs; [
        docker
        python314
        python314Packages.pip
        rustc
        cargo
        sqlite
        dotnet-sdk_11
        netcoredbg
        nodejs_26
        gcc
        gnumake
    ];
}
