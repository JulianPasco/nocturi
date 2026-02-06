# Shared Noctilia Shell configuration
# Used by both home and work machines
{ config, pkgs, hostname, userConfig, ... }:

{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        clipper = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screenshot = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };
    
    settings = {
      # Bar configuration
      bar = {
        position = "top";
        showCapsule = false;
        backgroundOpacity = 0.75;
        marginVertical = 4;
        marginHorizontal = 4;
        outerCorners = true;
        widgets = {
          left = [
            {
              id = "Workspace";
              labelMode = "name";
              hideUnoccupied = false;
              iconScale = 0.8;
              showLabelsOnlyWhenOccupied = true;
            }
            {
              id = "SystemMonitor";
              showCpuTemp = true;
              showCpuUsage = true;
              showMemoryUsage = true;
              compactMode = true;
              useMonospaceFont = true;
            }
            {
              id = "plugin:catwalk";
            }
            {
              id = "ActiveWindow";
              showIcon = true;
              maxWidth = 145;
              hideMode = "hidden";
            }
            {
              id = "MediaMini";
              maxWidth = 145;
              hideMode = "hidden";
              showAlbumArt = true;
              showProgressRing = true;
            }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
            }
          ];
          right = [
            {
              id = "Tray";
              colorizeIcons = false;
              drawerEnabled = true;
            }
            {
              id = "Network";
              displayMode = "onhover";
            }
            {
              id = "plugin:tailscale";
            }
            {
              id = "Bluetooth";
              displayMode = "onhover";
            }
            {
              id = "Volume";
              displayMode = "onhover";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
              id = "Brightness";
              displayMode = "onhover";
            }
            {
              id = "Battery";
              displayMode = "onhover";
              warningThreshold = 30;
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
            }
            {
              id = "plugin:clipper";
            }
            {
              id = "plugin:screenshot";
            }
            {
              id = "ControlCenter";
              icon = "noctalia";
            }
            {
              id = "SessionMenu";
              colorName = "secondary";
            }
          ];
        };
      };
      
      # Color scheme (Ayu)
      colorSchemes = {
        darkMode = true;
        predefinedScheme = "Ayu";
      };
      
      # UI settings
      ui = {
        fontDefault = "JetBrainsMono Nerd Font Propo";
        panelBackgroundOpacity = 0.93;
        boxBorderEnabled = false;
      };
      
      # General settings
      general = {
        avatarImage = "/home/${userConfig.username}/${userConfig.avatarImage}";
        radiusRatio = 1;
        iRadiusRatio = 1;
        boxRadiusRatio = 1;
        screenRadiusRatio = 1;
        lockOnSuspend = true;
        enableShadows = true;
        showChangelogOnStartup = false;  # Disable changelog/privacy popup
        telemetryEnabled = false;         # Disable telemetry
      };
      
      # Location settings
      location = {
        name = userConfig.location.city;
        latitude = userConfig.location.latitude;
        longitude = userConfig.location.longitude;
        weatherEnabled = true;
        weatherShowEffects = true;
        showCalendarEvents = true;
        showCalendarWeather = true;
      };
      
      # Calendar cards
      calendar = {
        cards = [
          { enabled = true; id = "calendar-header-card"; }
          { enabled = true; id = "calendar-month-card"; }
          { enabled = true; id = "weather-card"; }
        ];
      };
      
      # Wallpaper settings
      # Disabled directory scanning to avoid processing 161+ images on startup
      wallpaper = {
        enabled = true;
        overviewEnabled = false;
        directory = "";  # Disabled to prevent scanning 161 wallpapers
        fillMode = "crop";
        automationEnabled = false;
        wallpaperChangeMode = "manual";
        randomIntervalSec = 3600;
        transitionDuration = 500;
        transitionType = "fade";
      };
      
      # App Launcher
      appLauncher = {
        enableClipboardHistory = true;
        sortByMostUsed = true;
        viewMode = "list";
        showCategories = true;
      };
      
      # Control Center
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = false; id = "brightness-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
      };
      
      # Notifications
      notifications = {
        enabled = true;
        location = "top_right";
        normalUrgencyDuration = 8;
      };
      
      # Audio
      audio = {
        volumeStep = 5;
        cavaFrameRate = 30;
      };
      
      # Brightness
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
      };
      
      # Dock
      dock = {
        enabled = true;
        position = "left";
        displayMode = "exclusive";
        backgroundOpacity = 1.0;
        floatingRatio = 0.0;
        size = 1.18;
        colorizeIcons = true;
      };
      
      # Session Menu
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        largeButtonsStyle = false;
        largeButtonsLayout = "grid";
        showNumberLabels = true;
        powerOptions = [
          { action = "lock"; enabled = true; }
          { action = "suspend"; enabled = true; }
          { action = "hibernate"; enabled = true; }
          { action = "reboot"; enabled = true; }
          { action = "logout"; enabled = true; }
          { action = "shutdown"; enabled = true; }
        ];
      };
      
      # System Monitor
      systemMonitor = {
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
      };
      
      # Templates (enable theming for installed apps)
      # Reduced to essential templates only to minimize startup resource usage
      templates = {
        activeTemplates = [
          { enabled = false; id = "alacritty"; }
          { enabled = false; id = "btop"; }
          { enabled = false; id = "fuzzel"; }
          { enabled = false; id = "niri"; }
          { enabled = true; id = "kitty"; }  # Keep terminal theme
          { enabled = true; id = "gtk"; }    # Keep GTK theme
          { enabled = false; id = "telegram"; }
          { enabled = false; id = "yazi"; }
          { enabled = false; id = "kcolorscheme"; }
        ];
      };
      
      # Hooks - disabled to allow proper power management
      # The idle inhibitor was preventing system sleep/suspend
      hooks = {
        enabled = false;
        startup = "";
      };
    };
  };
}
