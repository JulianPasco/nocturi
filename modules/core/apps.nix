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
    
    # Spellcheck Dictionaries (System-wide for Office apps)
    hunspell
    hunspellDicts.en_GB-large
    hunspellDicts.en_US
  ];
  
  # Firefox with Wayland support
  programs.firefox.enable = true;
}
