{ pkgs, ... }:

let
  orchis-kde = pkgs.stdenv.mkDerivation {
    name = "orchis-kde";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Orchis-kde";
      rev = "master";
      sha256 = "0jn0n8187nn1d1j2w3qj32nd3zvr2v2d2qzv8lvxhdfpp5b41vcq";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/plasma/desktoptheme
      mkdir -p $out/share/plasma/look-and-feel
      cp -r plasma/desktoptheme/Orchis-dark $out/share/plasma/desktoptheme/
      cp -r plasma/look-and-feel/com.github.vinceliuice.Orchis-dark $out/share/plasma/look-and-feel/
      runHook postInstall
    '';
  };

  fluent-kde-aurorae = pkgs.stdenv.mkDerivation {
    name = "fluent-kde-aurorae";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-kde";
      rev = "master";
      sha256 = "14npk3ykgbhnp9f0izq7m1xpkak4glkmk9nxc3xbvdip7g0gcfhj";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/aurorae/themes
      cp -r aurorae/Fluent-round-dark-solid $out/share/aurorae/themes/
      runHook postInstall
    '';
  };

  win11-icon-theme = pkgs.stdenv.mkDerivation {
    name = "win11-icon-theme";
    src = pkgs.fetchFromGitHub {
      owner = "yeyushengfan258";
      repo = "Win11-icon-theme";
      rev = "master";
      sha256 = "09sish0afz3m5w68vmbn2rnfj69f78gx3b54fi9m6njjwn84wszq";
    };
    nativeBuildInputs = [ pkgs.gtk3 ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons
      bash install.sh -d $out/share/icons -t pink
      find $out -xtype l -delete
      runHook postInstall
    '';
  };

  afterglow-cursors = pkgs.stdenv.mkDerivation {
    name = "afterglow-cursors";
    src = ../themes/Afterglow-cursors;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons/Afterglow-cursors
      cp -r . $out/share/icons/Afterglow-cursors/
      runHook postInstall
    '';
  };

in
{
  home.packages = [
    orchis-kde
    fluent-kde-aurorae
    win11-icon-theme
    afterglow-cursors
  ];

  home.file.".local/share/color-schemes/noctalia.colors".source = ../themes/noctalia.colors;
}
