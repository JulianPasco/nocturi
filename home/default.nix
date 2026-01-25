# Home Manager configuration
{ config, pkgs, inputs, hostname, ... }:

{
  imports = [
    # Import the Noctilia home manager module
    inputs.noctalia.homeModules.default
  ];

  # Home Manager basic configuration
  home.username = "julian";
  home.homeDirectory = "/home/julian";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Enable and configure Noctilia Shell
  programs.noctalia-shell = {
    enable = true;
    # Enable the systemd service (recommended way to run Noctilia)
    systemd.enable = true;
    
    # Noctilia settings
    settings = {
      # Bar configuration
      bar = {
        density = "compact"; # "compact", "normal", or "relaxed"
        position = "top";    # "top", "left", "right", or "bottom"
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
              # Only show on the home PC that has bluetooth
              hidden = if (hostname == "work") then true else false;
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 20;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      
      # Color scheme
      colorSchemes.predefinedScheme = "Monochrome";
      
      # General settings
      general = {
        # Add your face image if you have one
        # avatarImage = "/home/julian/.face";
        radiusRatio = 0.2;
      };
      
      # Location settings
      location = {
        monthBeforeDay = false; # Format as day/month according to South African format
        name = "Johannesburg, South Africa";
      };
    };
  };

  # Configure Niri through home-manager
  xdg.configFile."niri/config.kdl".text = ''
    // User config file for niri

    // Set preferred terminal
    terminal { command "kitty"; }

    // XWayland configuration
    xwayland {
      enable true
      use_satellite true
    }

    // Auto-start Noctilia shell
    spawn_at_startup {
      command "noctalia-shell"
    }

    // Focus configuration
    focus {
      follow_mouse true
    }

    // Key bindings
    binds {
      keyboard {
        // Launcher
        "logo+r" "exec rofi -show drun"
        "logo+return" "exec kitty"

        // Window management
        "logo+q" "close"
        "logo+f" "toggle_fullscreen"
        "logo+e" "toggle_floating"

        // Switch workspaces
        "logo+1" "workspace 1"
        "logo+2" "workspace 2"
        "logo+3" "workspace 3"
        "logo+4" "workspace 4"
        "logo+5" "workspace 5"
        "logo+6" "workspace 6"
        "logo+7" "workspace 7"
        "logo+8" "workspace 8"
        "logo+9" "workspace 9"

        // Move windows to workspaces
        "logo+shift+1" "move_window_to_workspace 1"
        "logo+shift+2" "move_window_to_workspace 2"
        "logo+shift+3" "move_window_to_workspace 3"
        "logo+shift+4" "move_window_to_workspace 4"
        "logo+shift+5" "move_window_to_workspace 5"
        "logo+shift+6" "move_window_to_workspace 6"
        "logo+shift+7" "move_window_to_workspace 7"
        "logo+shift+8" "move_window_to_workspace 8"
        "logo+shift+9" "move_window_to_workspace 9"

        // Navigation
        "logo+h" "focus_column_left"
        "logo+j" "focus_window_down"
        "logo+k" "focus_window_up"
        "logo+l" "focus_column_right"

        // Moving windows
        "logo+shift+h" "move_window_left"
        "logo+shift+j" "move_window_down"
        "logo+shift+k" "move_window_up"
        "logo+shift+l" "move_window_right"

        // System/session
        "logo+shift+e" "quit"
        "logo+shift+r" "reload_config"
      }
    }
  '';

  # Additional programs to install
  home.packages = with pkgs; [
    # Install Niri to the user's profile
    inputs.niri-flake.packages.${system}.niri
    # System utilities
    htop
    btop
    neofetch
    
    # Development tools
    vscode

    # Wayland utilities
    rofi-wayland  # Application launcher
    swaylock     # Screen locker
    
    # Media
    mpv
    pavucontrol
  ];

  # Configure Git
  programs.git = {
    enable = true;
    userName = "Julian"; # Replace with your actual name
    userEmail = "julian@example.com"; # Replace with your actual email
  };

  # Configure terminal emulator (Kitty)
  programs.kitty = {
    enable = true;
    theme = "Monokai"; # Using standard Monokai theme instead of Monokai Pro
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
      update = "sudo nixos-rebuild switch --flake /etc/nixos#${hostname}";
    };
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

  # Home Manager state version
  home.stateVersion = "25.11";
}
