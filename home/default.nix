# Home Manager — entry point
# Imports focused sub-modules; only base identity + XDG live here.
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    ./apps.nix          # User application packages
    ./shell.nix         # Bash, Git, Kitty
    ./theming.nix       # GTK / cursor / icon theme
    ./plasma.nix        # KDE Plasma config (plasma-manager)
  ];

  # ── Identity ──────────────────────────────────────────────────────────────
  home.username    = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";
  programs.home-manager.enable = true;

  # ── XDG directories ───────────────────────────────────────────────────────
  xdg.enable = true;
  xdg.userDirs = {
    enable    = true;
    documents = "${config.home.homeDirectory}/Documents";
    download  = "${config.home.homeDirectory}/Downloads";
    pictures  = "${config.home.homeDirectory}/Pictures";
    videos    = "${config.home.homeDirectory}/Videos";
  };

  # ── State version (do not change) ─────────────────────────────────────────
  home.stateVersion = "25.11";
}
