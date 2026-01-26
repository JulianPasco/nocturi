{
  description = "NixOS configuration with Niri and Noctilia";

  inputs = {
    # NixOS unstable packages
    nixpkgs.url = "github:nixos/nixpkgs/c5296fdd05cfa2c187990dd909864da9658df755";
    
    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Niri window manager
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Noctilia shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/caf2302cea25c609c1ba7b6834f9e5aecff08a91";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, niri-flake, noctalia, ... }:
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
          ./modules/system/niri.nix
          # XWayland Satellite currently doesn't provide a NixOS module
          # We configure it directly in the niri.nix module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
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
