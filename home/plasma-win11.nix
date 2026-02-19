# Windows 11-style KDE Plasma 6 configuration via plasma-manager
{ config, lib, pkgs, userConfig, ... }:

{
  programs.plasma = {
    enable = true;

    # ── Workspace / global appearance ───────────────────────────────────────
    workspace = {
      # Fluent-round-dark look-and-feel: rounded corners + dark (closest to Windows 11)
      lookAndFeel = "com.github.vinceliuice.Fluent-round-dark";

      # Fluent-round Plasma desktop style (rounded panel/shell chrome)
      theme = "Fluent-round";

      # Fluent dark color scheme — proper Win11 blue (#0078D4) accent everywhere
      colorScheme = "FluentDark";

      # Fluent dark icons (Windows 11-style icon set)
      iconTheme = "Fluent-dark";

      # Cursor theme and size
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };

      # Fluent blue wallpaper (installed via fluent-kde system package)
      wallpaper = "/run/current-system/sw/share/wallpapers/Fluent/contents/images/1920x1080.png";
      wallpaperFillMode = "preserveAspectCrop";
    };

    # ── KWin compositor / effects ────────────────────────────────────────────
    kwin = {
      # Title bar buttons: Windows 11 style (minimize, maximize, close on right)
      titlebarButtons = {
        left  = [];
        right = [ "minimize" "maximize" "close" ];
      };

      # Blur behind transparent windows (Windows 11 mica/acrylic effect)
      effects = {
        blur = {
          enable = true;
          strength = 10;              # stronger = more frosted glass
          noiseStrength = 4;         # subtle noise texture (like Win11 Mica)
        };
        # Scale animation on open/close (Win11 opens windows with scale+fade)
        windowOpenClose.animation = "scale";
        desktopSwitching.animation = "slide";
        # Squash minimize to taskbar (like Windows 11)
        minimization.animation = "squash";
        wobblyWindows.enable = false;
        cube.enable = false;
      };

      # Maximized windows fill screen edge-to-edge (no title bar border)
      borderlessMaximizedWindows = true;

      # Night light — like Windows 11 Night Light (location-based)
      nightLight = {
        enable = true;
        mode = "location";
        location = {
          latitude  = toString userConfig.location.latitude;
          longitude = toString userConfig.location.longitude;
        };
        temperature = {
          day = 6500;
          night = 3800;
        };
        transitionTime = 30;
      };
    };

    # ── Fonts: Segoe UI 13pt (Windows 11) ───────────────────────────────────
    fonts = {
      general = {
        family = "Segoe UI";
        pointSize = 13;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
      small = {
        family = "Segoe UI";
        pointSize = 11;
      };
      toolbar = {
        family = "Segoe UI";
        pointSize = 13;
      };
      menu = {
        family = "Segoe UI";
        pointSize = 13;
      };
      windowTitle = {
        family = "Segoe UI";
        pointSize = 13;
        weight = "medium";
      };
    };

    # ── Windows 11-style bottom taskbar ──────────────────────────────────────
    panels = [
      {
        location = "bottom";
        height = 48;
        floating = true;

        widgets = [
          # Start button (App Launcher) — left side
          { name = "org.kde.plasma.kickoff"; }

          # Flexible spacer — pushes task icons to center
          { name = "org.kde.plasma.panelspacer"; }

          # Icons-only task manager (like Windows 11 centered taskbar)
          {
            iconTasks = {
              launchers = [];
              behavior = {
                grouping = {
                  method = "byProgramName";
                  clickAction = "cycle";
                };
                sortingMethod = "manually";
                minimizeActiveTaskOnClick = true;
                middleClickAction = "newInstance";
              };
            };
          }

          # Flexible spacer — balances left side
          { name = "org.kde.plasma.panelspacer"; }

          # System tray (notifications, volume, network, bluetooth, etc.)
          { name = "org.kde.plasma.systemtray"; }

          # Clock (right side, Windows 11 style — compact, time over date)
          {
            digitalClock = {
              date = {
                enable = true;
                format = { custom = "ddd d MMM"; };
                position = "belowTime";
              };
              time = {
                format = "24h";
                showSeconds = "never";
              };
              # Explicit font keeps the clock compact instead of auto-expanding
              font = {
                family = "Segoe UI";
                size = 13;
              };
              calendar = {
                firstDayOfWeek = "monday";
              };
            };
          }

          # Show Desktop button — far right corner (like Windows 11)
          { name = "org.kde.plasma.showdesktop"; }
        ];
      }
    ];

    # ── Low-level KDE config files ────────────────────────────────────────────
    configFile = {

      # Set Kvantum as the Qt widget style (enables transparency/blur in Qt apps)
      "kdeglobals"."KDE"."widgetStyle" = "kvantum";

      # Double-click to open files/folders (Windows 11 default behaviour)
      "kdeglobals"."KDE"."SingleClick" = false;

      # Use the FluentDark Kvantum theme (dark + transparent/blurred windows)
      "Kvantum/kvantum.kvconfig"."General"."theme" = "FluentDark";

      # KWin: Fluent-round-dark Aurorae window decoration (Win11 rounded corners)
      "kwinrc"."org.kde.kdecoration2"."library" = "org.kde.kwin.aurorae";
      "kwinrc"."org.kde.kdecoration2"."theme" = "__aurorae__svg__Fluent-round-dark";
      # NoSides = only the title bar, no side/bottom borders — exactly like Win11
      "kwinrc"."org.kde.kdecoration2"."BorderSize" = "NoSides";

      # KWin: ensure blur + contrast plugins are active
      "kwinrc"."Plugins"."blurEnabled" = true;
      "kwinrc"."Plugins"."contrastEnabled" = true;

      # Snappier animations (closer to Win11 responsiveness)
      "kwinrc"."Compositing"."AnimationSpeed" = 3;

      # Splash screen — Fluent look-and-feel boot animation
      "ksplashrc"."KSplash"."Engine" = "KSplashQML";
      "ksplashrc"."KSplash"."Theme" = "com.github.vinceliuice.Fluent-round-dark";
    };

    # ── Power / screen settings ────────────────────────────────────────────
    powerdevil = {
      AC = {
        turnOffDisplay = {
          idleTimeout = 900;
        };
      };
      battery = {
        turnOffDisplay = {
          idleTimeout = 300;
        };
      };
    };
  };
}
