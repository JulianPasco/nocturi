{
  description = "NixOS configuration with COSMIC Desktop";

  inputs = {
    # Use nixpkgs from nixos-cosmic for best COSMIC compatibility
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    
    # COSMIC Desktop flake (latest version with binary cache)
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    
    # Latest packages from unstable (for Windsurf)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-cosmic, home-manager, ... }:
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
          # Binary cache for COSMIC (prevents 30+ min builds)
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./hosts/${hostname}/configuration.nix
          ./modules/system/cosmic.nix
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
