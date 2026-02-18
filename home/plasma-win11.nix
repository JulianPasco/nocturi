# Windows 11-style KDE Plasma 6 configuration via plasma-manager
{ config, lib, pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    # ── Workspace / global appearance ───────────────────────────────────────
    workspace = {
      # Fluent-round-dark look-and-feel: rounded corners + dark (closest to Windows 11)
      lookAndFeel = "com.github.vinceliuice.Fluent-round-dark";

      # Fluent-round Plasma desktop style (rounded panel/shell chrome)
      theme = "Fluent-round";

      # Dark color scheme (Windows 11 dark mode)
      colorScheme = "BreezeDark";

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

      # Blur behind transparent windows (Windows 11 acrylic/mica effect)
      effects = {
        blur = {
          enable = true;
          strength = 8;
        };
        wobblyWindows.enable = false;
        cube.enable = false;
      };
    };

    # ── Fonts (Segoe UI-style clean sans-serif) ───────────────────────────────
    fonts = {
      general = {
        family = "Noto Sans";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
      small = {
        family = "Noto Sans";
        pointSize = 8;
      };
      toolbar = {
        family = "Noto Sans";
        pointSize = 10;
      };
      menu = {
        family = "Noto Sans";
        pointSize = 10;
      };
      windowTitle = {
        family = "Noto Sans";
        pointSize = 10;
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

          # Clock (right side, Windows 11 style)
          {
            digitalClock = {
              date = {
                enable = true;
                format = "shortDate";
                position = "belowTime";
              };
              time = {
                format = "24h";
                showSeconds = "never";
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

      # Use the FluentDark Kvantum theme (dark + transparent/blurred windows)
      "Kvantum/kvantum.kvconfig"."General"."theme" = "FluentDark";

      # KWin: Fluent-round-dark Aurorae window decoration (Win11 rounded corners)
      "kwinrc"."org.kde.kdecoration2"."library" = "org.kde.kwin.aurorae";
      "kwinrc"."org.kde.kdecoration2"."theme" = "__aurorae__svg__Fluent-round-dark";

      # KWin: ensure blur plugin is active (belt-and-suspenders with kwin.effects)
      "kwinrc"."Plugins"."blurEnabled" = true;

      # KWin: background contrast plugin (mica-like effect on panel/widgets)
      "kwinrc"."Plugins"."contrastEnabled" = true;
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
