{
    description = "JF's flake";

    inputs = {

        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/release-25.05";

        # Home-manager
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        astal = {
            url = "github:aylur/astal";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ags = {
            url = "github:aylur/ags";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.astal.follows = "astal";
        };

        # Zen browsers
        zen-browser = {
            url = "github:youwen5/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Stylix
        stylix = {
            url = "github:danth/stylix/release-25.05";
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

            # --- Share Descriptions --- #
            shareDescriptions =  [
                { name = "nextcloud"; address = "192.168.1.69"; }
                { name = "appdata"; address = "192.168.1.69"; }
                { name = "photo_video"; address = "192.168.1.69"; }
                { name = "media"; address = "192.168.1.69"; }
                { name = "documents"; address = "192.168.1.69"; }
            ];
                

            lib = nixpkgs.lib;
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
                        inputs.stylix.nixosModules.stylix
                    ];
                    specialArgs = {
                        inherit pkgs;
                        inherit systemSettings;
                        inherit userSettings;
                        inherit shareDescriptions;
                        inherit inputs;
                    };
                };

                # --- Desktop configuration --- #
                desktop = nixpkgs.lib.nixosSystem {
                    system = systemSettings.system;
                    modules = [
                        ./hosts/desktop/configuration.nix
                        inputs.stylix.nixosModules.stylix
                    ];
                    specialArgs = {
                        inherit pkgs;
                        inherit systemSettings;
                        inherit userSettings;
                        inherit shareDescriptions;
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
                        ./home/desktop.home.nix
                    ];
                    extraSpecialArgs = {
                        inherit pkgs;
                        inherit systemSettings;
                        inherit userSettings;
                        inherit inputs;
                    };
                };

                # --- Laptop Home-Manager --- #
                laptop = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                        ./home/laptop.home.nix
                    ];
                    extraSpecialArgs = {
                        inherit pkgs;
                        inherit systemSettings;
                        inherit userSettings;
                        inherit inputs;
                    };
                };
            };

        };
}
