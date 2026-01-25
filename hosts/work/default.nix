# Configuration for work PC
{ config, pkgs, inputs, hostname, ... }:

{
  imports = [
    # Hardware configuration will be generated when you rebuild on the work PC
    # You'll need to run `nixos-generate-config` on that machine first
    # For now we'll create a placeholder
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-work"; # Work machine hostname
  networking.networkmanager.enable = true;
  # No wireless and bluetooth for work PC
  
  # Time zone and locale
  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Disable GNOME desktop environment
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.displayManager.gdm.enable = false;

  # Enable only the X11 windowing system for compatibility
  # This is recommended to keep even with Wayland for XWayland support
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "za";
    variant = "";
  };

  # Enable sddm as display manager for Wayland sessions
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Enable Niri as Wayland compositor
  programs.niri.enable = true;

  # Enable printing support
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account
  users.users.julian = {
    isNormalUser = true;
    description = "Julian";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # User-specific packages
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # CLI utilities
    git
    kitty
    alacritty
    fastfetch
    curl
    wget
    vim
    
    # Wayland utilities
    wl-clipboard
    
    # For Noctilia functionality
    jq
    colordiff
  ];

  # Firefox with Wayland support
  programs.firefox = {
    enable = true;
    nativeWaylandEnabled = true;
  };

  # Enable experimental nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release
  system.stateVersion = "25.11"; # Keep the original value
}
