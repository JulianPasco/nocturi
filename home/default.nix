# Home Manager configuration
{ config, lib, pkgs, inputs, hostname, userConfig, ... }:

{
  # Home Manager basic configuration
  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Additional programs to install
  home.packages = with pkgs; [
    # System utilities
    htop
    btop
    
    # Development tools
    vscode
    windsurf  # From nixpkgs unstable
    gh  # GitHub CLI
    gedit  #text editor

    # Browsers
    google-chrome
    
    # File utilities
    file-roller        # Archive manager
    baobab             # Disk usage analyzer

    # Media utilities
    playerctl         # Media key support
    
    # Media
    mpv
    pavucontrol
    
    # Graphics & Photo Printing
    gimp

    # Disk tools
    gparted
    gsmartcontrol
    smartmontools
    popsicle


    # Network
    
    # Office & Productivity
    onlyoffice-desktopeditors
    evince  # PDF viewer
    
    # Cloud & Sync
    nextcloud-client
    
    # Communication
    zapzap  # WhatsApp client
    telegram-desktop
    
    # Security & Password Management
    bitwarden-desktop
    bitwarden-cli
    
    # Remote Desktop
    # rustdesk  # Commented out: takes 30+ min to compile
    anydesk
    # deskflow  # Removed: potential bloat/input interference
    
    # File Transfer & Development
    filezilla
    github-desktop
    
    # Fonts
    nerd-fonts.jetbrains-mono  # JetBrains Mono Nerd Font
  ];

  # Session variables for Wayland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  
  # GTK theming for compatibility with GTK apps
  gtk = {
    enable = true;
    
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Configure Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userConfig.fullName;
        email = userConfig.email;
      };
    };
  };

  # Configure terminal emulator (Kitty)
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13;
      enable_audio_bell = false;
      background_opacity = "0.80";
    };
  };

  # Configure bash
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

  xdg = {
    enable = true;
  };

  # Configure XDG directories
  xdg.userDirs = {
    enable = true;
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
  };

  # Home Manager state version
  home.stateVersion = "25.11";
}
