# Home Manager configuration
{ config, lib, pkgs, pkgs-unstable, inputs, hostname, userConfig, ... }:

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
    pkgs-unstable.windsurf  # Use unstable for latest version
    gh  # GitHub CLI
    gedit  #text editor

    # Browsers
    google-chrome
    
    # File manager & GNOME utilities
    nautilus
    file-roller        # Archive manager
    baobab             # Disk usage analyzer
    gnome-calculator   # Calculator
    simple-scan        # Document scanner

    # Media utilities
    playerctl         # Media key support
    
    # Media
    mpv
    pavucontrol
    
    # Graphics & Photo Printing
    gimp

    # Disk tools
    gparted
    gnome-disk-utility
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
    # rustdesk  # Commented out: takes 30+ min to compile, add back later if needed
    anydesk
    deskflow  # KVM software (Synergy fork)
    
    # File Transfer & Development
    filezilla
    github-desktop
    
    # Fonts
    nerd-fonts.jetbrains-mono  # JetBrains Mono Nerd Font
    inter                      # Inter font (closest to Win11 Segoe UI)
  ];

  # Session variables for Electron apps on Wayland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_ENABLE_WAYLAND = "1";
  };
  
  # GTK theming - Fluent Dark (Windows 11 style)
  gtk = {
    enable = true;
    
    theme = {
      name = "Fluent-Dark";
      package = pkgs.fluent-gtk-theme;
    };
    
    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };
    
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
  
  # Force overwrite existing GTK config files
  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

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

  # ========================================================================
  # GNOME Windows 11 Configuration
  # Extensions + dconf settings to make GNOME look and feel like Windows 11
  # ========================================================================

  # Enable and configure GNOME extensions via dconf
  dconf.settings = {
    # Enable installed extensions
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-panel@jderose9.github.com"
        "arcmenu@arcmenu.com"
        "blur-my-shell@auber.music"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "appindicatorsupport@rgcjonas.gmail.com"
        "rounded-window-corners@fxgn"
        "clipboard-indicator@tudmotu.com"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "google-chrome.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"
        "com.rtosta.zapzap.desktop"
        "codium.desktop"
        "org.telegram.desktop.desktop"
      ];
    };

    # --- Dash to Panel (Windows 11 taskbar) ---
    "org/gnome/shell/extensions/dash-to-panel" = {
      panel-positions = ''{"0":"BOTTOM","1":"BOTTOM"}'';
      panel-sizes = ''{"0":44,"1":44}'';
      panel-element-positions = ''{"0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'';
      show-apps-icon-file = "/home/${userConfig.username}/nixos-config/assets/windows11-start.svg";
      show-apps-icon-padding = 6;
      show-apps-icon-side-padding = 4;
      appicon-margin = 6;
      appicon-padding = 8;
      dot-style-focused = "SOLID";
      dot-style-unfocused = "DOTS";
      dot-position = "BOTTOM";
      animate-app-switch = true;
      animate-appicon-hover = true;
      animate-appicon-hover-animation-type = "SIMPLE";
      trans-use-custom-bg = true;
      trans-bg-color = "#000000";
      trans-use-custom-opacity = true;
      trans-panel-opacity = 0.92;
      show-tooltip = true;
      show-favorites = true;
      show-running-apps = true;
      group-apps = true;
      isolate-workspaces = false;
      click-action = "CYCLE-MIN";
      scroll-panel-action = "CYCLE_WINDOWS";
      hot-keys = true;
      shortcut-text = "";
      stockgs-keep-top-panel = true;  # Keep GNOME top panel visible (for Vitals + clock)
      stockgs-keep-dash = false;
      show-clock = false;  # Hide clock from bottom panel (keep in top panel only)
    };

    # --- ArcMenu (Runner only - triggered by Super key) ---
    "org/gnome/shell/extensions/arcmenu" = {
      # Hide ArcMenu's panel button (we use Dash to Panel's Show Apps button instead)
      menu-button-appearance = "Text";
      menu-button-custom-text = "";
      # Main layout set to Runner
      menu-layout = "Runner";
      # Standalone Runner: opens on Super key press
      enable-standlone-runner-menu = true;
      runner-menu-hotkey = "Super_L";
      runner-position = 0;  # Top centered
      runner-show-frequent-apps = true;
      runner-search-display-style = "List";
    };

    # --- Blur My Shell (Acrylic/Mica effect) ---
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.80;
      sigma = 18;
      noise-amount = 0.0;
      color-and-noise = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      brightness = 0.80;
      sigma = 15;
      override-background = true;
      style-panel = 0;
      override-background-dynamically = false;
      unblur-in-overview = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      style-components = 2;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
      blur = true;
      brightness = 0.82;
      sigma = 16;
      override-background = true;
      style-dash-to-panel = 0;
      unblur-in-overview = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      blur = true;
      sigma = 20;
    };

    # --- Just Perfection (UI fine-tuning) ---
    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = true;
      app-menu = false;
      search = true;
      dash = false;
      panel = true;
      startup-status = 0;  # Desktop (not overview)
      workspace-switcher-size = 0;
      animation = 2;  # Faster animations
      notification-banner-position = 1;  # Center
      hot-corner = true;  # Disable hot corners (not Win11 behavior)
      ripple-box = false;  # Disable click ripple
      window-demands-attention-focus = false;
      overlay-key = true;
      double-super-to-appgrid = true;
      window-maximized-on-create = false;
    };

    # --- Rounded Window Corners ---
    "org/gnome/shell/extensions/rounded-window-corners" = {
      global-rounded-corner-settings = "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <false>, 'fullscreen': <false>}>, 'border_radius': <uint32 8>, 'smoothing': <uint32 1>}";
      skip-libadwaita-app = false;
      skip-libhandy-app = false;
    };

    # --- Vitals (system resources in top panel) ---
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "_temperature_k10temp_tctl_"
        "_network-rx_enp42s0_"
      ];
      position-in-panel = 2;  # Right side of top panel
      use-higher-precision = false;
      show-temperature = true;
      show-voltage = false;
      show-fan = false;
      show-memory = true;
      show-processor = true;
      show-network = true;
      show-storage = false;
      show-battery = false;
      fixed-widths = true;
      hide-icons = false;
      icon-style = 1;  # Symbolic icons
    };

    # --- Clipboard Indicator ---
    "org/gnome/shell/extensions/clipboard-indicator" = {
      history-size = 50;
      preview-size = 100;
      move-item-first = true;
      enable-keybindings = true;
    };

    # --- GNOME Desktop Settings (Windows 11 feel) ---
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Fluent-Dark";
      icon-theme = "Fluent-dark";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
      font-name = "Inter 11";
      document-font-name = "Inter 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      enable-animations = true;
      clock-show-weekday = true;
      clock-show-seconds = false;
      show-battery-percentage = true;
      text-scaling-factor = 1.0;  # Default zoom (Inter font is already clean at native size)
    };

    # Window titlebar buttons (Windows 11: minimize, maximize, close on right)
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
      titlebar-font = "Inter Bold 11";
      action-double-click-titlebar = "toggle-maximize";
      action-middle-click-titlebar = "minimize";
      focus-mode = "click";
      num-workspaces = 4;
    };

    # Touchpad settings
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    # Keyboard settings
    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "za" ]) ];
    };

    # Background / Wallpaper
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/${userConfig.username}/${userConfig.wallpaperDir}/Balcony-ja.png";
      picture-uri-dark = "file:///home/${userConfig.username}/${userConfig.wallpaperDir}/Balcony-ja.png";
      picture-options = "zoom";
    };

    # Lock screen wallpaper
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/${userConfig.username}/${userConfig.wallpaperDir}/Balcony-ja.png";
      picture-options = "zoom";
      lock-delay = lib.hm.gvariant.mkUint32 30;
    };

    # Night light (replaces wlsunset)
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = 3700;
    };

    # Power settings
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 900;
    };

    # File manager (Nautilus) settings
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-hidden-files = false;
    };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
    };

    # Mutter (window manager) settings
    "org/gnome/mutter" = {
      edge-tiling = true;         # Windows-style snap to edges
      dynamic-workspaces = false; # Fixed workspaces like Windows
      center-new-windows = true;
      experimental-features = [ "scale-monitor-framebuffer" ];  # Fractional scaling support
    };

    # Keybindings (Windows 11 style)
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" "<Alt>F4" ];
      minimize = [ "<Super>h" ];
      toggle-maximized = [ "<Super>Up" ];
      show-desktop = [ "<Super>d" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
    };

    # Disable GNOME search providers for better performance
    "org/gnome/desktop/search-providers" = {
      disable-external = true;  # No external search providers
      disabled = [
        "org.gnome.Calculator.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.Contacts.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.Weather.desktop"
        "org.gnome.Software.desktop"
      ];
    };

    # Custom keybindings for app launchers
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
      home = [ "<Super>e" ];  # Open file manager (Windows style)
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "kitty";
      binding = "<Super>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Browser";
      command = "google-chrome-stable";
      binding = "<Super>b";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Windsurf";
      command = "windsurf";
      binding = "<Super>w";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "File Manager";
      command = "nautilus";
      binding = "<Super>f";
    };
  };

  # Home Manager state version
  home.stateVersion = "25.11";
}
