# GTK theming — Fluent dark (matches Windows 11 dark mode)
{ lib, pkgs, ... }:

{
  # Remove stale GTK backup files so home-manager can always activate cleanly
  home.activation.cleanGtkBackups = lib.hm.dag.entryBefore [ "checkFilesChanged" ] ''
    rm -f $HOME/.gtkrc-2.0.backup \
          $HOME/.config/gtk-3.0/settings.ini.backup \
          $HOME/.config/gtk-4.0/settings.ini.backup
  '';

  gtk = {
    enable = true;

    font = {
      name    = "Segoe UI";
      size    = 13;
      package = pkgs.vista-fonts;
    };

    theme = {
      name    = "Fluent-Dark";
      package = pkgs.fluent-gtk-theme;
    };

    iconTheme = {
      name    = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };

    cursorTheme = {
      name    = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size    = 24;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };
}
