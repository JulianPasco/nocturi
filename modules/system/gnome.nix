# GNOME desktop environment configuration
{ config, lib, pkgs, userConfig, ... }:

{
  # Enable GNOME Desktop Environment
  services.xserver.enable = true;
  services.displayManager.gdm = {
    enable = true;
    banner = "Welcome to NixOS";
  };
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
    # gnome-system-monitor # System monitor (keep: Shell uses it for system info)
    gnome-calendar       # Calendar (we don't use)
    evolution            # Email client (we don't use)
    # evolution-data-server # Calendar/contacts backend (heavy service)
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
  # services.gnome.localsearch.enable = false;
  # services.gnome.tinysparql.enable = false;

  # GNOME Shell extensions (system-level for availability)
  environment.systemPackages = with pkgs; [
    # Core GNOME utilities (needed by Shell/quick settings)
    gnome-system-monitor  # System info in quick settings
    
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
    
    # GNOME Shell Extensions (Windows 11 look - must be in systemPackages for GNOME to find them)
    gnomeExtensions.dash-to-panel
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals
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
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };
  
  # Disable accessibility services (Orca screen reader forces speechd)
  services.gnome.gnome-remote-desktop.enable = false;
  services.gnome.gnome-user-share.enable = false;
  services.gnome.rygel.enable = false;
  programs.gnome-terminal.enable = false;
  
  # Disable speech-dispatcher and Orca (common cause of app launch lag/hangs)
  services.speechd.enable = lib.mkForce false;
  services.orca.enable = lib.mkForce false;

  # Performance and auto-start optimizations
  environment.sessionVariables = {
    GNOME_SOFTWARE_AUTOSTART = "false";
  };

  # Disable evolution-data-server (heavy background service)
  # services.gnome.evolution-data-server.enable = lib.mkForce false;
  # services.gnome.gnome-online-accounts.enable = lib.mkForce false;
}
