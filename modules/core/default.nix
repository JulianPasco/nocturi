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
  imports = [
    ./apps.nix
    ./printing.nix
    ./networking.nix
    ./audio.nix
  ];

  # Bootloader configuration (common for all UEFI systems)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;  # Prevent filling up EFI partition
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Intel graphics optimizations for UHD 620 (Whiskey Lake)
  boot.kernelParams = [
    "i915.fastboot=1"           # Faster boot with display state preservation
    "i915.enable_fbc=1"         # Framebuffer compression (power + performance)
    "i915.enable_psr=2"         # Panel Self Refresh for power savings
  ];

  # Time zone and locale
  time.timeZone = userConfig.timezone;
  i18n.defaultLocale = userConfig.locale;

  # Configure console keymap for TTY login
  console.keyMap = "us";
  
  # Security and authentication services
  security.polkit.enable = true;

  # Enable touchpad support (tap-to-click) at login screen (SDDM)
  services.libinput.enable = true;

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

  # Enable nix-ld for running unpatched dynamic binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Common libraries often required by unpatched binaries
    stdenv.cc.cc
    zlib
    fuse3
    icu
    zstd
    nss
    openssl
    curl
    expat
  ];

  # Hardware firmware and SSD optimization
  hardware.enableRedistributableFirmware = true;
  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.smartd.enable = true;  # Monitor disk health (SMART)
  
  # Power management services
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  
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

    # Electron/Chromium apps (VS Code, Windsurf, Chrome) — native Wayland
    NIXOS_OZONE_WL           = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    # Firefox native Wayland backend
    MOZ_ENABLE_WAYLAND = "1";

    # GTK apps use XDG portals → KDE file/colour picker instead of GTK's own
    GTK_USE_PORTAL = "1";
  };

  # thermald handles Intel thermal management
  # power-profiles-daemon manages the CPU governor dynamically (performance/balanced/power-save)
  # → do NOT also set powerManagement.cpuFreqGovernor; they conflict
  services.thermald.enable = true;

  # DBus + dconf (programs.dconf.enable already registers the dbus service)
  services.dbus.enable = true;
  programs.dconf.enable = true;

  # Additional system services for desktop functionality
  services.accounts-daemon.enable = true;
  
  # Additional nix performance settings (base settings in nix-fast.nix)
  nix.settings = {
    # Parallel builds
    max-jobs = "auto";              # Use all available CPU cores
    cores = 0;                      # Let each job use all cores if needed
    
    # Logging
    log-lines = 200;                # More context in build logs
    
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

  # System-wide fonts (available to SDDM, all users, fontconfig)
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts            # Broad Unicode coverage fallback
      noto-fonts-cjk-sans   # CJK fallback
      noto-fonts-color-emoji  # Colour emoji
      vista-fonts           # Calibri, Cambria, Consolas, etc.
      nerd-fonts.jetbrains-mono  # Monospace for terminals
      inter                 # Required for Fluent SDDM theme

      # Microsoft Fonts & Compatibility (Critical for OnlyOffice/LibreOffice)
      corefonts             # Microsoft free fonts (Arial, Times, Comic Sans, etc.)
      liberation_ttf        # Metric-compatible with Arial, Times, Courier
      caladea               # Metric-compatible with Cambria
      carlito               # Metric-compatible with Calibri
      gelasio               # Metric-compatible with Georgia
      
      # Common document fonts
      roboto
      ubuntu-classic
      comic-neue
      lato
      open-sans
      montserrat
      source-sans
      source-serif
      dejavu_fonts
      gyre-fonts            # TeX Gyre (Helvetica/Arial, Times, etc. replacements)
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Segoe UI" "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };

  # This value determines the NixOS release
  system.stateVersion = "25.11";
}
