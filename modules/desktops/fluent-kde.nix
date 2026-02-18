{ config, lib, pkgs, ... }:

let
  fluent-kde = pkgs.stdenvNoCC.mkDerivation {
    pname = "fluent-kde";
    version = "2024-11-04";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-kde";
      rev = "main";
      hash = "sha256-Ejr2wDs3tr36YN2mWSd9ZKp5e6gH/whcuhauN/2Y15I=";
    };

    nativeBuildInputs = [ pkgs.bash ];

    installPhase = ''
      runHook preInstall

      # Kvantum themes (transparency/blur engine for Qt apps)
      mkdir -p $out/share/Kvantum
      for dir in Kvantum/*/; do
        [ -d "$dir" ] && cp -r "$dir" $out/share/Kvantum/
      done

      # Aurorae window decorations (Windows 11-style rounded corners)
      mkdir -p $out/share/aurorae/themes
      for dir in aurorae/*/; do
        [ -d "$dir" ] && cp -r "$dir" $out/share/aurorae/themes/
      done

      # Plasma desktop themes (panel/shell style)
      if [ -d plasma/desktoptheme ]; then
        mkdir -p $out/share/plasma/desktoptheme
        for dir in plasma/desktoptheme/*/; do
          [ -d "$dir" ] && cp -r "$dir" $out/share/plasma/desktoptheme/
        done
      fi

      # Look and Feel global themes
      mkdir -p $out/share/plasma/look-and-feel
      for dir in plasma/look-and-feel/*/; do
        [ -d "$dir" ] && cp -r "$dir" $out/share/plasma/look-and-feel/
      done

      # Plasmoids / widgets
      mkdir -p $out/share/plasma/plasmoids
      for dir in plasma/plasmoids/*/; do
        [ -d "$dir" ] && cp -r "$dir" $out/share/plasma/plasmoids/
      done

      # Layout templates
      if [ -d plasma/layout-templates ]; then
        mkdir -p $out/share/plasma/layout-templates
        for dir in plasma/layout-templates/*/; do
          [ -d "$dir" ] && cp -r "$dir" $out/share/plasma/layout-templates/
        done
      fi

      # Color schemes
      if [ -d color-schemes ]; then
        mkdir -p $out/share/color-schemes
        cp color-schemes/* $out/share/color-schemes/ 2>/dev/null || true
      fi

      # Wallpapers
      mkdir -p $out/share/wallpapers
      for dir in wallpaper/*/; do
        [ -d "$dir" ] && cp -r "$dir" $out/share/wallpapers/
      done

      # SDDM theme (Fluent-6.0 for modern SDDM / Plasma 6)
      mkdir -p $out/share/sddm/themes/Fluent
      cp -r sddm/Fluent-6.0/. $out/share/sddm/themes/Fluent/
      cp -r sddm/assets $out/share/sddm/themes/Fluent/
      cp -r sddm/backgrounds $out/share/sddm/themes/Fluent/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Fluent design (Windows 11 style) theme for KDE Plasma";
      homepage = "https://github.com/vinceliuice/Fluent-kde";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ fluent-kde ];

  # SDDM: use the Fluent theme (Windows 11-like login screen)
  services.displayManager.sddm = {
    theme = "Fluent";
    extraPackages = [ fluent-kde ];
  };
}
