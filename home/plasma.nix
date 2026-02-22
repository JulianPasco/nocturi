{ inputs, ... }:

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    enable = true;

    # ============================================================================
    # WORKSPACE APPEARANCE
    # ============================================================================

    workspace = {
      colorScheme = "noctalia";
      theme = "Orchis-dark";
      iconTheme = "Win11-blue-dark";
      cursor.theme = "Afterglow-cursors";

      splashScreen.theme = "com.github.vinceliuice.Orchis-dark";

      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__Fluent-round-dark-solid";
      };

      widgetStyle = "Breeze";
    };

    # ============================================================================
    # INPUT
    # ============================================================================

    input.keyboard.numlockOnStartup = "unchanged";

    # ============================================================================
    # PANEL
    # ============================================================================

    panels = [
      {
        location = "bottom";
        floating = true;
        height = 44;
        widgets = [
          { name = "org.kde.plasma.kickoff"; }
          { name = "org.kde.plasma.pager"; }
          {
            name = "org.kde.plasma.icontasks";
            config.General.launchers = "applications:systemsettings.desktop,preferred://filemanager,preferred://browser,applications:com.rtosta.zapzap.desktop";
          }
          { name = "org.kde.plasma.marginseparator"; }
          { name = "org.kde.plasma.systemtray"; }
          { name = "org.kde.plasma.digitalclock"; }
          { name = "org.kde.plasma.showdesktop"; }
        ];
      }
    ];

    # ============================================================================
    # KWIN SETTINGS
    # ============================================================================

    kwin = {
      titlebarButtons = {
        left = [];
        right = [ "minimize" "maximize" "close" ];
      };
    };

    # ============================================================================
    # EXTRA CONFIG (settings without a dedicated plasma-manager option)
    # ============================================================================

    kwin.tiling.padding = 4;

    configFile = {
      "kdeglobals"."KDE"."AnimationDurationFactor" = 0;

      "kwinrc"."Windows"."ElectricBorderCooldown" = 175;
      "kwinrc"."Xwayland"."Scale" = 1;
    };
  };
}
