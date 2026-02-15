# COSMIC desktop environment configuration
{ config, lib, pkgs, userConfig, ... }:

{
  # Enable COSMIC Desktop Environment
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Enable X11 support for compatibility with legacy apps
  services.xserver.enable = true;

  # System packages for COSMIC
  environment.systemPackages = with pkgs; [
    # Wayland clipboard
    wl-clipboard

    # Theming
    bibata-cursors          # Modern cursor theme
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
}
