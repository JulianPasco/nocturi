# COSMIC desktop environment configuration
{ config, lib, pkgs, userConfig, ... }:

{
  # Enable COSMIC Desktop Environment
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Enable X11 support for compatibility
  services.xserver.enable = true;

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;

  # System packages for COSMIC
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    xdg-utils
    wl-clipboard

    # Authentication
    polkit_gnome

    # Theming
    bibata-cursors          # Modern cursor theme
    
    # COSMIC utilities (if available separately)
    # cosmic-term
    # cosmic-files
    # cosmic-edit
  ];

  # Ensure necessary services are enabled
  services = {
    # For device mounting, trash functionality, etc.
    gvfs.enable = true;

    # For auto-mounting removable media
    udisks2.enable = true;
  };

  # Desktop portals for COSMIC
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-cosmic ];
    config.common.default = "cosmic";
  };

  # DBus services
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  # Additional system services for desktop functionality
  services.accounts-daemon.enable = true;
  programs.dconf.enable = true;
}
