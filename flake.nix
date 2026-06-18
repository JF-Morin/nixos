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

    outputs = { self, nixpkgs, home-manager, ... } @inputs:
        let
            # --- Settings --- #
            allSystems = import ./config/systems.nix;
            allUsers = import ./config/users.nix;
            allShares = import ./config/shares.nix;

            # Define lib module
            #lib = nixpkgs.lib;

            # Helper functions
            mkNixOSConfiguration =
                {
                inputs,
                sysConfig,
                nixpkgs,
                home-manager,
                modules ? [ ],
                }:
                nixpkgs.lib.nixosSystem {
                    # System type
                    system = sysConfig.system.arch;

                    # Special args for the config file
                    specialArgs = {
                        inherit sysConfig inputs;
                    }; 

                    # Modules to include
                    modules = [
                        # Unfree pkgs
                        {
                            nixpkgs.config.allowUnfree = true;
                            nixpkgs.config.allowUnfreePredicate = (_:true);
                        }

                        # Configuration (common config file)
                        ./nixos/hosts/configuration.nix

                        # Stylix
                        inputs.stylix.nixosModules.stylix

                        # Home-Manager
                        home-manager.nixosModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;

                            # Creating nome-manager users dynamically
                            home-manager.users = builtins.listToAttrs (map (user:
                                let
                                    # Set the userHomePath and if not found, take the default one
                                    userHomePath = ./homeManager/${user.username}.home.nix;
                                    homeFilePath = if builtins.pathExists userHomePath
                                        then userHomePath
                                    else ./homeManager/home.nix;
                                in 
                                    {
                                    name = user.username;
                                    #value = import homeFilePath {inherit user sysConfig inputs;}; 
                                    value = {config, pkgs, lib, ...}:{
                                        imports = [
                                            homeFilePath
                                        ];
                                        _module.args = {inherit user sysConfig inputs;};
                                    };
                                }
                            ) sysConfig.users);
                        }

                    ] ++ modules;
                };

        in {
            # --- Configurations --- #
            nixosConfigurations = builtins.mapAttrs (systemName: system: 
                let
                    systemUsers = map (username: allUsers.${username}) system.users;
                in 
                    mkNixOSConfiguration {
                        inherit nixpkgs home-manager inputs;
                        sysConfig = {
                            inherit system;
                            users = systemUsers;
                            shares = allShares;
                        };
                    }
            ) allSystems;

        };
}
