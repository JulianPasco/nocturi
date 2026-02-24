# Home Manager configuration
# All user applications and programs in one organized file
{ config, lib, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    ./themes.nix
    ./plasma.nix
  ];

  # ============================================================================
  # BASIC CONFIGURATION
  # ============================================================================
  
  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";
  programs.home-manager.enable = true;

  # ============================================================================
  # PACKAGES - All applications organized by category
  # ============================================================================
  
  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # CLI UTILITIES
    # --------------------------------------------------------------------------
    git
    fastfetch
    curl
    wget
    nmap
    vim
    htop
    btop
    usbutils
    pciutils
    lshw
    jq
    colordiff
    
    # --------------------------------------------------------------------------
    # WAYLAND UTILITIES
    # --------------------------------------------------------------------------
    wl-clipboard
    
    # --------------------------------------------------------------------------
    # BROWSERS
    # --------------------------------------------------------------------------
    google-chrome
    
    # --------------------------------------------------------------------------
    # DEVELOPMENT TOOLS
    # --------------------------------------------------------------------------
    vscode
    windsurf
    gh
    filezilla
    github-desktop
    
    # --------------------------------------------------------------------------
    # OFFICE & PRODUCTIVITY
    # --------------------------------------------------------------------------
    onlyoffice-desktopeditors
    
    # --------------------------------------------------------------------------
    # COMMUNICATION
    # --------------------------------------------------------------------------
    zapzap
    telegram-desktop
    
    # --------------------------------------------------------------------------
    # CLOUD & SYNC
    # --------------------------------------------------------------------------
    nextcloud-client
    
    # --------------------------------------------------------------------------
    # MEDIA
    # --------------------------------------------------------------------------
    mpv
    pavucontrol
    playerctl
    
    # --------------------------------------------------------------------------
    # GRAPHICS & PHOTO
    # --------------------------------------------------------------------------
    gimp
    
    # --------------------------------------------------------------------------
    # DISK TOOLS
    # --------------------------------------------------------------------------
    gparted
    gsmartcontrol
    smartmontools
    popsicle
    
    # --------------------------------------------------------------------------
    # SECURITY & PASSWORD MANAGEMENT
    # --------------------------------------------------------------------------
    bitwarden-desktop
    bitwarden-cli
    
    # --------------------------------------------------------------------------
    # REMOTE DESKTOP
    # --------------------------------------------------------------------------
    anydesk
    
    # --------------------------------------------------------------------------
    # FONTS
    # --------------------------------------------------------------------------
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # ENVIRONMENT & SESSION VARIABLES
  # ============================================================================
  
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # ============================================================================
  # PROGRAM CONFIGURATIONS
  # ============================================================================
  
  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userConfig.fullName;
        email = userConfig.email;
      };
    };
  };

  # Terminal emulator (Kitty)
  programs.kitty.enable = true;

  # Bash shell configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      update = "nixos-update";
      upgrade = "nixos-upgrade";
    };
    bashrcExtra = ''
      # NixOS helpers (work across devices)
      _nixos_config_dir() {
        if [ -n "$NIXOS_CONFIG_DIR" ]; then
          printf "%s" "$NIXOS_CONFIG_DIR"
        else
          printf "%s" "${config.home.homeDirectory}/nixos-config"
        fi
      }

      nixos-update() {
        local dir
        dir="$(_nixos_config_dir)"
        if [ ! -f "$dir/flake.nix" ]; then
          echo "NixOS config not found at: $dir" >&2
          echo "Set NIXOS_CONFIG_DIR or clone the repo to that path." >&2
          return 1
        fi
        sudo nixos-rebuild switch --no-reexec --option binary-caches-parallel-connections 40 --flake "$dir#${hostname}"
      }

      nixos-upgrade() {
        local dir
        dir="$(_nixos_config_dir)"
        if [ ! -f "$dir/flake.nix" ]; then
          echo "NixOS config not found at: $dir" >&2
          echo "Set NIXOS_CONFIG_DIR or clone the repo to that path." >&2
          return 1
        fi
        if [ -f "$dir/flake.lock" ] && [ ! -w "$dir/flake.lock" ]; then
          echo "flake.lock is not writable in: $dir" >&2
          echo "Fix: sudo chown -R $USER:$USER \"$dir\"" >&2
          return 1
        fi
        (cd "$dir" && nix flake update) && \
          sudo nixos-rebuild switch --no-reexec --option binary-caches-parallel-connections 40 --flake "$dir#${hostname}"
      }
    '';
  };

  # ============================================================================
  # XDG CONFIGURATION
  # ============================================================================
  
  xdg = {
    enable = true;
    
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # ============================================================================
  # STATE VERSION
  # ============================================================================
  
  home.stateVersion = "25.11";
}
