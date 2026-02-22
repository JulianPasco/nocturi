{ config, lib, pkgs, ... }:

{
  # Enable KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;
  
  # Enable SDDM display manager with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;  # Prefer Wayland session
    theme = "breeze";       # Explicitly use default Breeze theme
  };
  
  # X11/Wayland support
  services.xserver.enable = true;   # X11 input drivers and session support
  programs.xwayland.enable = true;  # X11 app compatibility on Wayland
  
  # XDG Desktop Portal (file chooser, screen sharing, etc)
  # xdg-desktop-portal-kde is auto-added by plasma6; gtk is a fallback for non-KDE apps
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  # KDE Connect (phone integration - open firewall ports automatically)
  programs.kdeconnect.enable = true;

  # Flatpak support (required for Discover to install Flatpak apps)
  services.flatpak.enable = true;

  # KDE/Plasma packages for complete desktop experience
  environment.systemPackages = with pkgs; [
    # KDE Core Applications
    kdePackages.dolphin              # File manager
    kdePackages.konsole              # Terminal emulator
    kdePackages.kate                 # Text editor
    kdePackages.ark                  # Archive manager
    kdePackages.spectacle            # Screenshot tool
    kdePackages.okular               # Document viewer
    kdePackages.gwenview             # Image viewer
    kdePackages.kcalc                # Calculator
    kdePackages.partitionmanager     # Partition manager

    # KDE System utilities
    kdePackages.plasma-systemmonitor # System monitor
    kdePackages.kinfocenter          # System information
    kdePackages.filelight            # Disk usage analyzer
    kdePackages.plasma-disks         # Disk health monitoring (SMART)
    kdePackages.sddm-kcm             # Login screen settings in System Settings

    # KDE Network & Bluetooth
    kdePackages.plasma-nm            # NetworkManager applet
    kdePackages.bluedevil            # Bluetooth manager

    # Browser integration (requires browser extension)
    kdePackages.plasma-browser-integration

    # KDE Store support (themes, extensions, plasmoids, window decorations)
    kdePackages.discover              # KDE app store (handles KDE Store installs)
    kdePackages.flatpak-kcm           # Flatpak management in System Settings
    packagekit                        # Backend for system package installs via Discover

    # Kvantum theme engine (for third-party themes with blur/transparency)
    kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum (Plasma 6 apps)
    libsForQt5.qtstyleplugin-kvantum  # Qt5 Kvantum (legacy Qt5 apps)

    # KDE Media
    kdePackages.elisa              # Music player
    kdePackages.kdenlive           # Video editor
    kdePackages.kamera             # Camera device support
    kdePackages.kamoso             # Webcam app
    haruna                         # Modern video player (Qt/KDE)

    # KDE Graphics & Photo
    krita                          # Digital painting
    kdePackages.kolourpaint        # Simple paint program

    # KDE Productivity
    kdePackages.merkuro            # Calendar & contacts
    kdePackages.kget               # Download manager
    kdePackages.kompare            # Diff/patch tool

    # KDE Remote Desktop
    kdePackages.krfb               # Desktop sharing (VNC server)
    kdePackages.krdc               # Remote desktop client
  ];

  # KWallet: unlock on SDDM login and on TTY/other login
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  # Polkit for privileged operations (partition manager, etc.)
  security.polkit.enable = true;
}
