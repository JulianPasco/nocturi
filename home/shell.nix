# Shell, terminal, and developer tool configuration
{ config, pkgs, hostname, userConfig, ... }:

{
  # ── Git ──────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = userConfig.fullName;
        email = userConfig.email;
      };
    };
  };

  # ── Kitty terminal ────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    settings = {
      font_family        = "JetBrainsMono Nerd Font";
      font_size          = 13;
      enable_audio_bell  = false;
      background_opacity = "0.80";
    };
  };

  # ── Bash ──────────────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;
    shellAliases = {
      ll     = "ls -la";
      update = "nixos-update";
      upgrade = "nixos-upgrade";
    };
    bashrcExtra = ''
      # NixOS helpers (work across devices)
      _nixos_config_dir() {
        if [ -n "$NIXOS_CONFIG_DIR" ]; then
          printf "%s" "$NIXOS_CONFIG_DIR"
        else
          printf "%s" "${config.home.homeDirectory}/nixos-config"
        fi
      }

      nixos-update() {
        local dir
        dir="$(_nixos_config_dir)"
        if [ ! -f "$dir/flake.nix" ]; then
          echo "NixOS config not found at: $dir" >&2
          echo "Set NIXOS_CONFIG_DIR or clone the repo to that path." >&2
          return 1
        fi
        sudo nixos-rebuild switch --no-reexec --option binary-caches-parallel-connections 40 --flake "$dir#${hostname}"
      }

      nixos-upgrade() {
        local dir
        dir="$(_nixos_config_dir)"
        if [ ! -f "$dir/flake.nix" ]; then
          echo "NixOS config not found at: $dir" >&2
          echo "Set NIXOS_CONFIG_DIR or clone the repo to that path." >&2
          return 1
        fi
        if [ -f "$dir/flake.lock" ] && [ ! -w "$dir/flake.lock" ]; then
          echo "flake.lock is not writable in: $dir" >&2
          echo "Fix: sudo chown -R $USER:$USER \"$dir\"" >&2
          return 1
        fi
        (cd "$dir" && nix flake update) && \
          sudo nixos-rebuild switch --no-reexec --option binary-caches-parallel-connections 40 --flake "$dir#${hostname}"
      }
    '';
  };
}
