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
              characterCount = 2;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              labelMode = "name";
              showApplications = false;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            {
              id = "SystemMonitor";
              compactMode = true;
              diskPath = "/";
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskUsage = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = false;
              showSwapUsage = false;
              useMonospaceFont = true;
              usePrimaryColor = false;
            }
            {
              id = "plugin:catwalk";
              defaultSettings = {
                hideBackground = false;
                minimumThreshold = 10;
              };
            }
            {
              id = "ActiveWindow";
              colorizeIcons = false;
              hideMode = "hidden";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              useFixedWidth = false;
            }
            {
              id = "MediaMini";
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              maxWidth = 145;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = false;
              useFixedWidth = false;
              visualizerType = "linear";
            }
          ];
          center = [
            {
              id = "Taskbar";
              colorizeIcons = false;
              iconScale = 0.8;
              maxTaskbarWidth = 40;
              onlyActiveWorkspaces = true;
              onlySameOutput = false;
              showPinnedApps = true;
              showTitle = false;
              smartWidth = true;
              titleWidth = 120;
              hideMode = "hidden";
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
              defaultSettings = {
                compactMode = false;
                defaultPeerAction = "copy-ip";
                hideDisconnected = false;
                pingCount = 5;
                refreshInterval = 5000;
                showIpAddress = true;
                showPeerCount = true;
                terminalCommand = "";
              };
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
              deviceNativePath = "";
              displayMode = "onhover";
              hideIfIdle = false;
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
              warningThreshold = 30;
            }
            {
              id = "plugin:clipper";
              defaultSettings = {
                position = "Bottom";
              };
            }
            {
              id = "plugin:screenshot";
              defaultSettings = {
                mode = "region";
              };
            }
            {
              id = "ControlCenter";
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              useDistroLogo = false;
            }
            {
              id = "Clock";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = false;
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
        useWallpaperColors = false;
        predefinedScheme = "Ayu";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generationMethod = "tonal-spot";
        monitorForColors = "";
      };
      
      # UI settings
      ui = {
        fontDefault = "JetBrainsMono Nerd Font Propo";
        fontFixed = "monospace";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        networkPanelView = "wifi";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
      };
      
      # General settings
      general = {
        avatarImage = "/home/${userConfig.username}/${userConfig.avatarImage}";
        dimmerOpacity = 0.2;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        iRadiusRatio = 1;
        boxRadiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        compactLockScreen = false;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
        showHibernateOnLockScreen = false;
        enableShadows = true;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        language = "";
        allowPanelsOnScreenWithoutBar = true;
        showChangelogOnStartup = false;
        telemetryEnabled = false;
        enableLockScreenCountdown = true;
        lockScreenCountdownDuration = 10000;
      };
      
      # Location settings
      location = {
        name = userConfig.location.city;
        latitude = userConfig.location.latitude;
        longitude = userConfig.location.longitude;
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherTimezone = false;
        hideWeatherCityName = false;
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
        monitorDirectories = [];
        enableMultiMonitorDirectories = false;
        showHiddenFiles = false;
        viewMode = "single";
        setWallpaperOnAllMonitors = true;
        fillMode = "crop";
        fillColor = "#000000";
        useSolidColor = false;
        solidColor = "#1a1a2e";
        automationEnabled = false;
        wallpaperChangeMode = "random";
        randomIntervalSec = 3600;
        transitionDuration = 500;
        transitionType = "fade";
        transitionEdgeSmoothness = 0.05;
        panelPosition = "follow_bar";
        hideWallpaperFilenames = false;
        useWallhaven = false;
        wallhavenQuery = "";
        wallhavenSorting = "relevance";
        wallhavenOrder = "desc";
        wallhavenCategories = "111";
        wallhavenPurity = "100";
        wallhavenRatios = "";
        wallhavenApiKey = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenResolutionHeight = "";
      };
      
      # App Launcher
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        position = "center";
        pinnedApps = [];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "list";
        showCategories = true;
        iconMode = "tabler";
        showIconBackground = false;
        enableSettingsSearch = true;
        ignoreMouseInput = false;
        screenshotAnnotationTool = "";
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
        monitors = [];
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        saveToHistory = {
          low = true;
          normal = true;
          critical = true;
        };
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          criticalSoundFile = "";
          normalSoundFile = "";
          lowSoundFile = "";
          excludedApps = "discord,firefox,chrome,chromium,edge";
        };
        enableMediaToast = false;
      };
      
      # Audio
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
        mprisBlacklist = [];
        preferredPlayer = "";
        volumeFeedback = false;
      };
      
      # Brightness
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = false;
      };
      
      # Dock
      dock = {
        enabled = false;
        position = "left";
        displayMode = "exclusive";
        backgroundOpacity = 1.0;
        floatingRatio = 0.0;
        size = 1.18;
        onlySameOutput = true;
        monitors = [];
        pinnedApps = [];
        colorizeIcons = true;
        pinnedStatic = false;
        inactiveIndicators = false;
        deadOpacity = 0.6;
        animationSpeed = 1;
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
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        swapWarningThreshold = 80;
        swapCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        cpuPollingInterval = 3000;
        tempPollingInterval = 3000;
        gpuPollingInterval = 3000;
        enableDgpuMonitoring = false;
        memPollingInterval = 3000;
        diskPollingInterval = 30000;
        networkPollingInterval = 3000;
        loadAvgPollingInterval = 3000;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
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
