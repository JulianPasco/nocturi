# Niri window manager configuration
{ config, pkgs, inputs, ... }:

{
  # Enable Niri from the flake
  programs.niri = {
    enable = true;
    package = inputs.niri-flake.packages.${pkgs.system}.niri;

    # Additional system-wide settings for Niri can go here
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "za";
          };
        };
        
        # Touchpad settings if needed
        touchpad = {
          natural-scroll = true;
          tap = true;
        };
      };
      
      # Ensure XWayland is enabled for compatibility with X11 apps
      xwayland = {
        enable = true;
        # Enable XWayland Satellite for better X11 app integration
        use-satellite = true;
      };
      
      # Default outputs/display settings
      outputs = {};
    };
  };

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;
  
  # Enable XWayland Satellite service
  services.xwayland-satellite.enable = true;

  # Make sure we have all necessary dependencies for a functional Wayland session
  environment.systemPackages = with pkgs; [
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
    
    # Desktop portals for app integration
    xdg-desktop-portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
