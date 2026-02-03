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

  # XDG Portal configuration moved to modules/system/niri.nix to avoid conflicts
  
  # Security and authentication services
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;  # Secret service for passwords
  
  # Enable polkit authentication agent (graphical permission dialogs)
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  
  # Calendar events support for Noctilia Shell
  services.gnome.evolution-data-server.enable = true;

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
  
  # Graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit apps and games
  };
  
  # DBus services
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };
  
  # Additional system services for desktop functionality
  services.accounts-daemon.enable = true;  # User account information
  programs.dconf.enable = true;             # Settings backend
  
  # Session variables for Wayland apps
  environment.sessionVariables = {
    # Qt Wayland support
    QT_QPA_PLATFORM = "wayland;xcb";  # Prefer Wayland, fallback to X11
    # SDL Wayland support
    SDL_VIDEODRIVER = "wayland";
    # Clutter backend
    CLUTTER_BACKEND = "wayland";
  };

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
