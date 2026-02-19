# User application packages
{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # ── System utilities ─────────────────────────────────────────────────────
    htop
    btop

    # ── Development ──────────────────────────────────────────────────────────
    vscode
    windsurf
    gh              # GitHub CLI
    github-desktop
    filezilla

    # ── Browsers ─────────────────────────────────────────────────────────────
    google-chrome

    # ── Media ────────────────────────────────────────────────────────────────
    mpv
    playerctl       # Media key / MPRIS control

    # ── Graphics ─────────────────────────────────────────────────────────────
    gimp

    # ── Disk utilities ───────────────────────────────────────────────────────
    gsmartcontrol
    smartmontools
    popsicle        # USB flash tool

    # ── Office & Productivity ─────────────────────────────────────────────────
    onlyoffice-desktopeditors

    # ── Cloud & Sync ──────────────────────────────────────────────────────────
    nextcloud-client

    # ── Communication ─────────────────────────────────────────────────────────
    zapzap          # WhatsApp client
    telegram-desktop

    # ── Security & Passwords ──────────────────────────────────────────────────
    bitwarden-desktop
    bitwarden-cli

    # ── Remote access ─────────────────────────────────────────────────────────
    anydesk
    # rustdesk  # Commented out: takes 30+ min to compile

  ];
}
