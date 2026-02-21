{ config, lib, pkgs, ... }:

{
  # Enable KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;
  
  # Enable SDDM display manager with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;  # Prefer Wayland session
  };
  
  # Wayland support for desktop
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

    # Qt theming — Qt5 legacy apps + Qt6 (Plasma 6 native)
    kdePackages.qtstyleplugin-kvantum  # Kvantum theme engine for Qt6 apps
    libsForQt5.qtstyleplugin-kvantum   # Kvantum theme engine for Qt5 legacy apps
    libsForQt5.qt5ct                   # Qt5 app styling configuration tool
  ];

  # KWallet: unlock on SDDM login and on TTY/other login
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  # Polkit for privileged operations (partition manager, etc.)
  security.polkit.enable = true;
}
