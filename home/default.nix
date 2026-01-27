# Home Manager configuration
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    # Import the Noctilia home manager module
    inputs.noctalia.homeModules.default
    # Shared Noctilia configuration (synced between home and work)
    ../modules/home/noctilia.nix
  ];

  # Home Manager basic configuration
  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Noctilia Shell configuration is imported from ../modules/home/noctilia.nix
  # This allows settings to be shared between home and work machines

  # Configure Niri through home-manager
  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration
    // Based on default config: https://yalter.github.io/niri/Configuration:-Introduction

    input {
        keyboard {
            xkb {
                layout "za"
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
            // Default settings
        }
    }

    layout {
        gaps 16
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 4
            active-color "#7fc8ff"
            inactive-color "#505050"
        }

        border {
            off
        }
    }

    // Start XWayland satellite for X11 apps (Chrome, Windsurf, VSCode)
    spawn-at-startup "xwayland-satellite" ":0"

    environment {
        DISPLAY ":0"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    animations {
        // slowdown 1.0
    }

    binds {
        // Launch applications
        Mod+T { spawn "kitty"; }
        Mod+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Super+Escape { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // Window management
        Mod+Q { close-window; }

        // Focus movement
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        // Move windows
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        // Monitor focus
        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }

        // Workspace navigation
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+U         { focus-workspace-down; }
        Mod+I         { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        // Workspace by number
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        // Column management
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Window sizing
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Floating windows
        Mod+V { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        // Screenshots
        Mod+S { screenshot; }
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // System
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
    }
  '';

  # Additional programs to install
  home.packages = with pkgs; [
    # Install Niri to the user's profile
    inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable
    
    # System utilities
    htop
    btop
    neofetch
    
    # Development tools
    vscode
    windsurf
    gh  # GitHub CLI

    # Browsers
    google-chrome
    
    # File manager
    nemo

    # Wayland utilities
    
    # Screenshot tools (from tutorial)
    grim         # Screenshot utility for Wayland
    slurp        # Screen area selection for Wayland
    wl-clipboard # Wayland clipboard utilities
    
    # Noctilia Shell dependencies
    brightnessctl     # Required: Brightness control
    imagemagick       # Required: Template processing & wallpaper resizing
    python3           # Required: Template processing
    cliphist          # Optional: Clipboard history support
    cava              # Optional: Audio visualizer
    wlsunset          # Optional: Night light functionality
    xdg-desktop-portal-gtk  # Portal support for screen recorder
    evolution-data-server  # Calendar events support
    
    # Media
    mpv
    pavucontrol

    # Network
    tailscale
    
    # Office & Productivity
    onlyoffice-desktopeditors
    impression  # Modern presentation tool
    
    # Cloud & Sync
    nextcloud-client
    
    # Communication
    zapzap  # WhatsApp client
    telegram-desktop
    
    # Security & Password Management
    bitwarden-desktop
    bitwarden-cli
    
    # Remote Desktop
    # rustdesk  # Commented out: takes 30+ min to compile, add back later if needed
    anydesk
    deskflow  # KVM software (Synergy fork)
    
    # File Transfer & Development
    filezilla
    github-desktop
    
    # Fonts (from tutorial)
    nerd-fonts.jetbrains-mono  # JetBrains Mono Nerd Font
  ];

  # Session variables for Wayland and Electron apps
  home.sessionVariables = {
    # Enable Wayland for compatible apps
    NIXOS_OZONE_WL = "1";
    # Electron apps can use Wayland or fall back to XWayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
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
      font_family = "Hack";
      font_size = 11;
      enable_audio_bell = false;
      background_opacity = "0.95";
    };
  };

  # Configure bash
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake /home/julian/nixos-config#${hostname}";
      startniri = "niri-session";  # Quick alias to start Niri
    };
    # Auto-start Niri on TTY1 with guard variable to prevent infinite loop
    profileExtra = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && [ -z "$NIRI_LOADED" ]; then
        export NIRI_LOADED=1
        exec niri-session
      fi
    '';
  };

  # Add .desktop entries for autostarting Noctilia
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

  # Import Wayland environment variables into systemd user environment
  # This fixes wlr portal not starting - systemd needs WAYLAND_DISPLAY
  systemd.user.services.import-wayland-env = {
    Unit = {
      Description = "Import Wayland env vars into systemd user environment";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Home Manager state version
  home.stateVersion = "25.11";
}