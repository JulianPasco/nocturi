# Configuration for home PC
{ config, pkgs, inputs, hostname, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS configuration
  # This was already in your original configuration
  boot.initrd.luks.devices."luks-794928c8-0140-44c3-8efe-88c3625a4b07".device = "/dev/disk/by-uuid/794928c8-0140-44c3-8efe-88c3625a4b07";

  # Networking
  networking.hostName = "nixos-home"; # Change hostname
  networking.networkmanager.enable = true;
  # Enable wireless and bluetooth for home PC
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;

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

  # Firefox
  programs.firefox.enable = true;

  # Enable Firefox Wayland support via environment variable
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # Enable experimental nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release
  system.stateVersion = "25.11"; # Keep the original value
}
