# Niri window manager configuration
{ config, pkgs, inputs, ... }:

{
  # Enable Niri from the flake
  programs.niri = {
    enable = true;
    package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };
  
  # Set up a basic Niri config file
  environment.etc."niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
          layout "za"
        }
      }
      
      touchpad {
        natural_scroll true
        tap true
      }
    }
    
    xwayland {
      enable true
      use_satellite true
    }
  '';

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;
  
  # Make sure we have all necessary dependencies for a functional Wayland session
  environment.systemPackages = with pkgs; [
    # XWayland Satellite package
    inputs.xwayland-satellite-unstable.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
    
    # Wayland essentials
    wayland
    xdg-utils
    xwayland
    
    # Screen recording/sharing support
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    pipewire  # Needed for screen sharing
    
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
  
  # Desktop portals for app integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
