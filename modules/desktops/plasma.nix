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
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk  # GTK file chooser fallback
    ];
    xdgOpenUsePortal = true;
  };

  # Essential KDE/Plasma packages for complete desktop experience
  environment.systemPackages = with pkgs; [
    # KDE Applications
    kdePackages.dolphin              # File manager
    kdePackages.konsole              # Terminal emulator
    kdePackages.kate                 # Text editor
    kdePackages.ark                  # Archive manager
    kdePackages.spectacle            # Screenshot tool
    kdePackages.okular               # Document viewer
    kdePackages.gwenview             # Image viewer
    kdePackages.kcalc                # Calculator
    kdePackages.partitionmanager     # Partition manager (KDE's alternative to GParted)
    
    # KDE System utilities
    kdePackages.plasma-systemmonitor # System monitor
    kdePackages.kinfocenter          # System information
    kdePackages.filelight            # Disk usage analyzer
    
    # KDE Network & Bluetooth
    kdePackages.plasma-nm            # NetworkManager applet
    kdePackages.bluedevil            # Bluetooth manager
    
    # Additional desktop utilities
    libsForQt5.qtstyleplugin-kvantum # Theme engine for Qt apps
    libsForQt5.qt5ct                 # Qt5 configuration tool
  ];
  
  # Enable KWallet for password management
  security.pam.services.sddm.enableKwallet = true;
  
  # Enable NetworkManager applet
  programs.nm-applet.enable = true;
  
  # Partition Manager needs polkit rules
  security.polkit.enable = true;
}
