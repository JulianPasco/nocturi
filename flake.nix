{
  description = "NixOS configuration with GNOME (Windows 11 style)";

  inputs = {
    # NixOS unstable packages
    nixpkgs.url = "github:nixos/nixpkgs/c5296fdd05cfa2c187990dd909864da9658df755";
    
    # Latest packages from unstable (for Windsurf)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      
      # Import user configuration
      userConfig = import ./user-config.nix;
      
      # Function to create NixOS configuration for each host
      mkHost = hostname: extraModules: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hostname userConfig pkgs-unstable; };
        modules = [
          ./hosts/${hostname}/configuration.nix
          ./modules/system/gnome.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";  # Backup existing files that would be overwritten
              extraSpecialArgs = { inherit inputs hostname userConfig pkgs-unstable; };
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
