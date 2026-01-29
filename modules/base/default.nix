# Shared base configuration for all hosts
# Contains all common settings between home and work PCs
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  # Bootloader configuration (common for all UEFI systems)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking (hostname set per-host)
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = userConfig.timezone;
  i18n.defaultLocale = userConfig.locale;

  # Disable GNOME desktop environment and X11
  # Using pure Wayland with Niri - no display manager needed
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;
  services.xserver.enable = false;

  # Configure console keymap for TTY login
  console.keyMap = "us";

  # Enable Niri as Wayland compositor
  programs.niri.enable = true;
  
  # XDG Portal configuration for Niri (file picker support)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.niri = {
      default = pkgs.lib.mkForce [ "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };
  
  # Security and authentication services (recommended for Niri)
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;  # Secret service for passwords
  
  # Calendar events support for Noctilia Shell
  services.gnome.evolution-data-server.enable = true;

  # Enable printing support
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      splix
      gutenprint
      cnijfilter2  # Canon PIXMA drivers
    ];
  };
  
  # Enable network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define user account
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages (common utilities)
  environment.systemPackages = with pkgs; [
    # CLI utilities
    git
    kitty
    alacritty
    fastfetch
    curl
    wget
    vim
    usbutils
    
    # Wayland utilities
    wl-clipboard
    
    # For Noctilia functionality
    jq
    colordiff
  ];
  
  # Power management services
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  
  # Enable Tailscale VPN
  services.tailscale.enable = true;

  # Firefox with Wayland support
  programs.firefox.enable = true;
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # Additional nix performance settings (base settings in nix-fast.nix)
  nix.settings = {
    # Parallel builds
    max-jobs = "auto";              # Use all available CPU cores
    cores = 0;                      # Let each job use all cores if needed
    
    # Logging
    log-lines = 200;                # More context in build logs
    
    # Additional binary cache for niri (beyond nix-fast.nix defaults)
    substituters = [
      "https://niri.cachix.org"      # Niri binary cache for faster window manager builds
    ];
    
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
    
    # Remote builder optimization
    builders-use-substitutes = true;  # Let builders use binary caches
  };
  
  # Increase build users for better parallelization
  nix.nrBuildUsers = 64;
  
  # Use zram instead of disk swap for better performance
  zramSwap = {
    enable = true;
    memoryPercent = 50;             # Use 50% of RAM for compressed swap
    algorithm = "zstd";             # Fast compression
  };
  
  # VM tuning for better performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;                # Prefer RAM over swap
    "vm.vfs_cache_pressure" = 50;        # Keep filesystem cache longer
    "vm.dirty_background_ratio" = 5;     # Start background writeback at 5% dirty pages
    "vm.dirty_ratio" = 15;               # Force synchronous writes at 15% dirty pages
  };
  
  # Use performance CPU governor for faster builds
  powerManagement.cpuFreqGovernor = "performance";
  
  # Use tmpfs for builds (builds in RAM for massive speed boost)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";         # Use 50% of RAM for /tmp (adjust if needed)

  # tmpfs cache for faster desktop performance (3GB in-memory cache)
  fileSystems."/home/${userConfig.username}/.cache" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=3G" "mode=700" "uid=1000" "gid=100" ];
  };

  # This value determines the NixOS release
  system.stateVersion = "25.11";
}
