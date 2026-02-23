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
            config.General.launchers = "applications:systemsettings.desktop,preferred://filemanager,preferred://browser,applications:com.rtosta.zapzap.desktop,applications:org.kde.konsole.desktop,applications:windsurf.desktop,applications:onlyoffice-desktopeditors.desktop";
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

      "kactivitymanagerd-statsrc"."Favorites-org.kde.plasma.kickoff.favorites.instance-154-6a9de4b8-8443-42cd-82f0-96383c68f821"."ordering" = "applications:org.kde.discover.desktop,applications:org.kde.dolphin.desktop,applications:systemsettings.desktop,preferred://browser,applications:AnyDesk.desktop,applications:firefox.desktop";
      "kactivitymanagerd-statsrc"."Favorites-org.kde.plasma.kickoff.favorites.instance-154-global"."ordering" = "applications:org.kde.discover.desktop,applications:org.kde.dolphin.desktop,applications:systemsettings.desktop,preferred://browser,applications:AnyDesk.desktop,applications:firefox.desktop";
      "kactivitymanagerd-statsrc"."Favorites-org.kde.plasma.kickoff.favorites.instance-3-6a9de4b8-8443-42cd-82f0-96383c68f821"."ordering" = "applications:org.kde.discover.desktop,applications:org.kde.dolphin.desktop,applications:systemsettings.desktop,preferred://browser,applications:AnyDesk.desktop,applications:firefox.desktop";
      "kactivitymanagerd-statsrc"."Favorites-org.kde.plasma.kickoff.favorites.instance-3-global"."ordering" = "applications:org.kde.discover.desktop,applications:org.kde.dolphin.desktop,applications:systemsettings.desktop,preferred://browser,applications:AnyDesk.desktop,applications:firefox.desktop";

      "kwinrc"."Windows"."ElectricBorderCooldown" = 175;
      "kwinrc"."Xwayland"."Scale" = 1;
    };
  };
}
