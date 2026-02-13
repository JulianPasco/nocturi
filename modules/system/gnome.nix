# GNOME desktop environment configuration
{ config, lib, pkgs, ... }:

{
  # Enable GNOME Desktop Environment
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
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
    gnome-software  # Software center (we use nix)
    gnome-console   # Terminal (we use kitty)
    gnome-text-editor # Text editor (we use gedit/vscode)
    gnome-logs      # Log viewer
    snapshot        # Camera app
    gnome-system-monitor # System monitor (we use htop/btop)
    gnome-calendar       # Calendar (we don't use)
    evolution            # Email client (we don't use)
    evolution-data-server # Calendar/contacts backend (heavy service)
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

  # Disable GNOME file indexing (major performance drain)
  services.gnome.localsearch.enable = false;
  services.gnome.tinysparql.enable = false;

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
    gnomeExtensions.clipboard-indicator    # Clipboard manager (Win+V)
    gnomeExtensions.vitals                 # System resources (CPU, RAM, temp, net)
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

  # Performance and auto-start optimizations
  environment.sessionVariables = {
    GNOME_SOFTWARE_AUTOSTART = "false";
    MUTTER_DEBUG_ENABLE_ATOMIC_KMS = "1";  # Better frame pacing
    MUTTER_DEBUG_FORCE_KMS_MODE = "simple"; # Reduce compositor overhead
  };

  # Disable evolution-data-server (heavy background service)
  services.gnome.evolution-data-server.enable = false;
  services.gnome.gnome-online-accounts.enable = false;
}
