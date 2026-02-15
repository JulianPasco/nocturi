{
  description = "NixOS configuration with COSMIC Desktop";

  inputs = {
    # Use latest NixOS unstable for COSMIC support (built-in as of 25.05+)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
          ./hosts/${hostname}/configuration.nix
          ./modules/system/cosmic.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";  # Backup existing files that would be overwritten
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
