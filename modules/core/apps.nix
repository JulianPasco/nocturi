{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # CLI utilities
    git
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
  ];
  
  # Firefox with Wayland support
  programs.firefox.enable = true;
}
