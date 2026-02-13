# GNOME desktop environment configuration
{ config, lib, pkgs, ... }:

{
  # Enable GNOME Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;

  # Remove GNOME bloat - keep only essentials
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    epiphany        # GNOME Web browser (we use Chrome/Firefox)
    geary           # Email client
    gnome-contacts
    gnome-maps
    gnome-weather
    gnome-clocks
    gnome-connections
    yelp            # Help viewer
    gnome-characters
    totem           # Video player (we use mpv)
    tali
    iagno
    hitori
    atomix
    gnome-mines
    gnome-sudoku
    gnome-mahjongg
    gnome-chess
    gnome-robots
    gnome-tetravex
    gnome-taquin
    gnome-nibbles
    gnome-klotski
    four-in-a-row
    five-or-more
    lightsoff
    swell-foop
    quadrapassel
  ];

  # GNOME Shell extensions (system-level for availability)
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    xdg-utils

    # Authentication
    polkit_gnome

    # GNOME tweaking tools
    gnome-tweaks
    dconf-editor

    # Windows 11 theme packages
    fluent-gtk-theme        # Windows 11-style GTK theme
    fluent-icon-theme       # Windows 11-style icon theme
    bibata-cursors          # Modern cursor theme

    # GNOME Shell extensions for Windows 11 look
    gnomeExtensions.dash-to-panel          # Windows-style taskbar
    gnomeExtensions.arcmenu                # Windows 11 start menu
    gnomeExtensions.blur-my-shell          # Blur effects (acrylic/mica)
    gnomeExtensions.user-themes            # Custom shell themes
    gnomeExtensions.just-perfection        # Fine-tune shell appearance
    gnomeExtensions.appindicator           # System tray icons
    gnomeExtensions.rounded-window-corners-reborn  # Rounded corners like Win11
    gnomeExtensions.compiz-windows-effect  # Window animations
    gnomeExtensions.clipboard-indicator    # Clipboard manager (Win+V)
    gnomeExtensions.gsconnect              # Phone integration
  ];

  # Ensure necessary services are enabled
  services = {
    # For device mounting, trash functionality, etc.
    gvfs.enable = true;

    # For auto-mounting removable media
    udisks2.enable = true;
  };

  # Desktop portals (GNOME handles this automatically, but ensure it's enabled)
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
