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
      wallpaper = {
        enabled = true;
        overviewEnabled = false;
        directory = "/home/${userConfig.username}/${userConfig.wallpaperDir}";
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
        position = "bottom";
        displayMode = "auto_hide";
        backgroundOpacity = 0.61;
        floatingRatio = 0.22;
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
      templates = {
        activeTemplates = [
          { enabled = true; id = "alacritty"; }
          { enabled = true; id = "btop"; }
          { enabled = true; id = "fuzzel"; }
          { enabled = true; id = "niri"; }
          { enabled = true; id = "kitty"; }
          { enabled = true; id = "gtk"; }
          { enabled = true; id = "telegram"; }
          { enabled = true; id = "yazi"; }
          { enabled = true; id = "kcolorscheme"; }
        ];
      };
      
      # Hooks - enable keep awake and set power profile to powersaver on startup
      hooks = {
        enabled = true;
        startup = "noctalia-shell ipc call idleInhibitor enable && noctalia-shell ipc call powerProfile set powersaver";
      };
    };
  };
}
