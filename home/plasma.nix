# KDE Plasma configuration via plasma-manager
# Uses the default Breeze theme (KDE Plasma 6 default)
{ ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = true;  # Wipe existing KDE config; only declarative settings apply

    workspace = {
      lookAndFeel   = "org.kde.breeze.desktop";  # Default Plasma 6 look-and-feel
      colorScheme   = "BreezeDark";               # Default dark colour scheme
      cursorTheme   = "breeze_cursors";           # Default Breeze cursor
      iconTheme     = "breeze";                   # Default Breeze icons
    };
  };
}
