# Shared base configuration for all hosts
# Contains all common settings between home and work PCs
{ config, lib, pkgs, inputs, hostname, userConfig, ... }:

let
  userName = userConfig.username;
  user = config.users.users.${userName};
  userUid = if user.uid == null then 1000 else user.uid;
  userGroupName = if user.group == null then "users" else user.group;
  userGroup = config.users.groups.${userGroupName} or null;
  userGid =
    if userGroup == null || userGroup.gid == null
    then 100
    else userGroup.gid;
in {
  # Bootloader configuration (common for all UEFI systems)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Intel graphics optimizations for UHD 620 (Whiskey Lake)
  boot.kernelParams = [
    "i915.fastboot=1"           # Faster boot with display state preservation
    "i915.enable_fbc=1"         # Framebuffer compression (power + performance)
    "i915.enable_psr=2"         # Panel Self Refresh for power savings
  ];

  # Networking (hostname set per-host)
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Time zone and locale
  time.timeZone = userConfig.timezone;
  i18n.defaultLocale = userConfig.locale;

  # Configure console keymap for TTY login
  console.keyMap = "us";
  
  # Security and authentication services
  security.polkit.enable = true;

  # Enable printing support
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      splix
      gutenprint
      cnijfilter2  # Canon PIXMA drivers
      epson-escpr   # Epson ESC/P-R driver for older Epson printers
      epson-escpr2  # Epson ESC/P-R driver for newer Epson printers (EcoTank, WorkForce, etc)
    ];
  };
  
  # Enable network printer discovery and scanner support
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  # Enable scanner support (SANE)
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];  # For network scanners (AirScan/eSCL)
  };

  # Enable sound with pipewire
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
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "video"        # Screen brightness, GPU access
      "audio"        # Audio device access
      "input"        # Input device access
      "storage"      # Removable media access
      "dialout"      # Serial port access
      "scanner"      # Scanner access
      "lp"           # Printer/scanner access
    ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hardware firmware and SSD optimization
  hardware.enableRedistributableFirmware = true;
  services.fstrim.enable = true;
  services.fwupd.enable = true;

  # System-wide packages (common utilities)
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
  
  # Power management services
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  
  # Enable Tailscale VPN
  services.tailscale.enable = true;

  # Firefox with Wayland support
  programs.firefox.enable = true;
  
  # Graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit apps and games
    extraPackages = with pkgs; [
      intel-media-driver  # LIBVA_DRIVER_NAME=iHD (modern)
      intel-vaapi-driver  # LIBVA_DRIVER_NAME=i965 (legacy)
      libvdpau-va-gl
    ];
  };
  
  # Force Intel iHD driver for hardware acceleration (better for UHD 620)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
  
  # CPU power management for responsiveness (Intel i7-8565U)
  powerManagement.cpuFreqGovernor = "schedutil";  # Better than ondemand for interactive workloads
  services.thermald.enable = true;  # Intel thermal management
  
  # DBus services
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };
  
  # Additional system services for desktop functionality
  services.accounts-daemon.enable = true;  # User account information
  programs.dconf.enable = true;             # Settings backend
  
  # Additional nix performance settings (base settings in nix-fast.nix)
  nix.settings = {
    # Parallel builds
    max-jobs = "auto";              # Use all available CPU cores
    cores = 0;                      # Let each job use all cores if needed
    
    # Logging
    log-lines = 200;                # More context in build logs
    
    substituters = [];
    trusted-public-keys = [];
    
    # Remote builder optimization
    builders-use-substitutes = true;  # Let builders use binary caches
  };
  
  # Increase build users for better parallelization
  nix.nrBuildUsers = 64;
  
  # Use zram instead of disk swap for better performance
  zramSwap = {
    enable = true;
    memoryPercent = 30;             # Use 30% of RAM for compressed swap (reduced from 50%)
    algorithm = "zstd";             # Fast compression
  };
  
  # VM tuning for better performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;                # Prefer RAM over swap
    "vm.vfs_cache_pressure" = 50;        # Keep filesystem cache longer
    "vm.dirty_background_ratio" = 5;     # Start background writeback at 5% dirty pages
    "vm.dirty_ratio" = 15;               # Force synchronous writes at 15% dirty pages
  };
  
  # Use tmpfs for builds (builds in RAM for massive speed boost)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "25%";         # Use 25% of RAM for /tmp (reduced from 50%)

  # tmpfs cache for faster desktop performance (1.5GB in-memory cache)
  # Reduced from 3GB to prevent RAM exhaustion
  fileSystems."/home/${userConfig.username}/.cache" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=1536M"
      "mode=700"
      "nofail"
      "x-systemd.automount"
      "uid=${toString userUid}"
      "gid=${toString userGid}"
    ];
  };

  # This value determines the NixOS release
  system.stateVersion = "25.11";
}
