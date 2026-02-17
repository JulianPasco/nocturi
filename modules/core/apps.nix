{ config, lib, pkgs, userConfig, ... }:

{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    git
    alacritty
    fastfetch
    curl
    wget
    vim
    usbutils
    pciutils
    lshw
    
    # Wayland utilities
    wl-clipboard
    
    # General utilities
    jq
    colordiff
  ];
  
  # Firefox with Wayland support
  programs.firefox.enable = true;
}
