{
    description = "JF's flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... } @ inputs:
        let
            # --- System Settings --- #
            systemSettings = {
                system = "x86_64-linux";
                hostname = "";
                timezone = "Europe/Paris";
                locale = "en_CA.UTF-8";
                bootMode = "uefi";
            };

            # --- User Settings --- #
            userSettings = rec {
                username = "jf";
                name = "JF";
                email = "jfmorincamo@gmail.com";
                theme = "";
                wm = "hyprland";
                dotfileDir = "";
                browser = "brave";
                wmType = "wayland";
                term = "ghostty";
                editor = "neovim";
            };

            lib = nixpkgs.lib;
            #pkgs = nixpkgs.legacyPackages.${systemSettings.system};
            pkgs = import inputs.nixpkgs {
               system = systemSettings.system;
               config = {
                   allowUnfree = true;
                   allowUnfreePredicate = (_:true);
               };
            };

        in {
            # --- Configurations --- #
            nixosConfigurations = {

                # --- Laptop configuration --- #
                laptop = nixpkgs.lib.nixosSystem {
                    system = systemSettings.system;
                    modules = [
                        ./hosts/laptop/configuration.nix
                    ];
                    specialArgs = {
                        inherit pkgs;
                        inherit systemSettings;
                        inherit userSettings;
                        inherit inputs;
                    };
                };

                # --- Desktop configuration --- #
                desktop = nixpkgs.lib.nixosSystem {
                    system = systemSettings.system;
                    modules = [
                        ./hosts/desktop/configuration.nix
                    ];
                    specialArgs = {
                        inherit pkgs;
                        inherit systemSettings;
                        inherit userSettings;
                        inherit inputs;
                    };
                };
            };

            # --- Home-manager configurations --- #
            homeConfigurations= {

                # --- Desktop Home-Manager --- #
                desktop = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                        ./home-manager/desktop.home.nix
                    ];
                };

                # --- Laptop Home-Manager --- #
                laptop = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                        ./home-manager/laptop.home.nix
                    ];
                };
            };

        };
}
