{
    description = "JF's flake";

    inputs = {

        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home-manager
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Zen browsers
        zen-browser = {
            url = "github:youwen5/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Quickshell
        quickshell = {
            url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Noctalia
        noctalia = {
            url = "github:noctalia-dev/noctalia";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Noctalia Greeter (separate project)
        noctalia-greeter = {
            url = "github:noctalia-dev/noctalia-greeter";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, quickshell, noctalia, ... } @ inputs:
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
                nixpkgs-unstable,
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

                        # Noctalia shell
                        inputs.noctalia.nixosModules.default

                        # Noctalia Greeter (provides services.displayManager.noctalia-greeter)
                        inputs.noctalia-greeter.nixosModules.default

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
                        inherit nixpkgs nixpkgs-unstable home-manager inputs;
                        sysConfig = {
                            inherit system;
                            users = systemUsers;
                            shares = allShares;
                        };
                    }
            ) allSystems;

        };
}
