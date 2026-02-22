{
  description = "NixOS configuration with KDE Plasma Desktop";

  inputs = {
    # Use latest NixOS unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma Manager for declarative KDE Plasma configuration
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Import user configuration
      userConfig = import ./user-config.nix;
      
      # Function to create NixOS configuration for each host
      mkHost = hostname: extraModules: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hostname userConfig; };
        modules = [
          ./hosts/${hostname}/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = null;
              backupCommand = ''
                if [[ -e "$1" ]]; then
                  backup="$1.backup"
                  counter=1
                  while [[ -e "$backup" ]]; do
                    backup="$1.backup.$counter"
                    ((counter++))
                  done
                  mv "$1" "$backup"
                fi
              '';
              extraSpecialArgs = { inherit inputs hostname userConfig; };
              users.${userConfig.username} = import ./home;
            };
          }
        ] ++ extraModules;
      };
    in
    {
      # NixOS configurations for each host
      nixosConfigurations = {
        # Home PC (current)
        home = mkHost "home" [];
        
        # Work PC
        work = mkHost "work" [];
      };
    };
}
