# Niri window manager configuration
{ config, pkgs, inputs, ... }:

{
  # Enable Niri from the flake
  programs.niri = {
    enable = true;
    package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };
  
  # User config is managed through home-manager
  # No system-level config.kdl needed

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;
  
  # Make sure we have all necessary dependencies for a functional Wayland session
  environment.systemPackages = with pkgs; [
    # XWayland Satellite package from niri-flake
    inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
    
    # Wayland essentials
    wayland
    xdg-utils
    xwayland
    
    # Authentication
    polkit_gnome
  ];
  
  # Ensure necessary services are enabled
  services = {
    # For device mounting, trash functionality, etc.
    gvfs.enable = true;
    
    # For auto-mounting removable media
    udisks2.enable = true;
  };
  
  # Desktop portals for app integration with deterministic backend order
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [ "wlr" "gtk" ];
      };
    };
  };
}
