{ config, lib, pkgs, ... }:

{
  # Networking (hostname set per-host)
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  
  # Enable Tailscale VPN
  services.tailscale.enable = true;
}
