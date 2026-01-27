# Niri + Noctilia + NixOS

**A modern, beautiful, and performant NixOS desktop configuration featuring Niri's scrollable-tiling compositor and Noctilia Shell's stunning interface.**

[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg)](https://nixos.org/)
[![Niri](https://img.shields.io/badge/Compositor-Niri-orange.svg)](https://github.com/YaLTeR/niri)
[![Noctilia](https://img.shields.io/badge/Shell-Noctilia-purple.svg)](https://github.com/noctalia-dev/noctalia-shell)

## ✨ Features

- **🎨 Beautiful by Default**: Noctilia Shell with Ayu theme
- **🪟 Unique Window Management**: Niri's scrollable-tiling compositor
- **⚡ Blazing Fast**: zram swap, tmpfs caching, optimized VM settings
- **🔒 Secure**: Wayland-native, no X11, proper portal configuration
- **📦 Reproducible**: NixOS flakes ensure identical setups across machines
- **🧩 DRY Architecture**: Shared base config, host-specific overrides only
- **⚙️ Easy Customization**: Single `user-config.nix` file for personal settings

## 🎥 What You Get

### Niri Compositor
- Scrollable-tiling window management (Super+H/L to scroll)
- Smooth 60fps animations
- Per-monitor workspaces
- Dynamic workspace creation
- Native Wayland, no X11 dependencies

### Noctilia Shell
- Stunning desktop shell with widgets
- App launcher with fuzzy search
- Control center with power profiles
- Lock screen that matches your theme
- System monitor, calendar, weather
- Media controls and notifications

### Performance Optimizations
- **zram**: 50% RAM compressed swap
- **tmpfs**: 3GB in-memory cache
- **VM tuning**: Optimized swappiness and dirty ratios
- **Nix caching**: Fast rebuilds with parallel builds
- **Auto GC**: Weekly cleanup of old generations

### Included Applications
- **Development**: VSCode, Windsurf, GitHub Desktop
- **Browsers**: Google Chrome, Firefox
- **Office**: OnlyOffice, Impression (presentations)
- **Communication**: Telegram, Zapzap (WhatsApp)
- **Cloud**: Nextcloud client
- **Security**: Bitwarden
- **Remote**: AnyDesk, Deskflow (KVM)
- **Media**: MPV, Pavucontrol
- **File Management**: Nautilus, FileZilla
- **System**: htop, btop, neofetch

See `home/default.nix` for complete list.

## 📦 Quick Start

> **Note:** These instructions are for a fresh NixOS installation. Just copy and paste each command!

---

### Step 1: Open the NixOS configuration file

```bash
sudo nano /etc/nixos/configuration.nix
```

---

### Step 2: Add git and enable flakes

Find a spot in the file and add these two lines:

```nix
environment.systemPackages = [ pkgs.git ];
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Then save the file: **Press `Ctrl+O`, then `Enter`, then `Ctrl+X`**

---

### Step 3: Apply the changes

```bash
sudo nixos-rebuild switch
```

---

### Step 4: Clone the repository

```bash
git clone https://github.com/JulianPasco/nocturi.git ~/nixos-config
```

---

### Step 5: Edit your personal settings

```bash
nano ~/nixos-config/user-config.nix
```

Update these values with your information:
- `username` - Your Linux username
- `fullName` - Your name
- `email` - Your email
- `timezone` - Your timezone (e.g., `"Europe/London"`, `"America/New_York"`)
- `locale` - Your locale (e.g., `"en_US.UTF-8"`)

Save: **Press `Ctrl+O`, then `Enter`, then `Ctrl+X`**

---

### Step 6: Copy your hardware configuration

**For desktop/work machine:**
```bash
cp -a /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/work/
```

**For laptop/home machine:**
```bash
cp -a /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/home/
```

---

### Step 7: Deploy!

**For desktop/work:**
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#work
```

**For laptop/home:**
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#home
```

---

### Step 8: Reboot

```bash
sudo reboot
```

✅ **Done!** After reboot, log in at the terminal and Niri will start automatically.

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Super+T` | Terminal (Kitty) |
| `Super+D` / `Super+Space` | Launcher |
| `Super+Escape` | Lock screen |
| `Super+Q` | Close window |
| `Super+H/L` | Scroll workspaces |
| `Super+Shift+H/L` | Move window between workspaces |
| `Super+Left/Right/Up/Down` | Focus window |

See `home/default.nix` for complete list.

## 📂 Structure

```
├── flake.nix                    # Flake configuration
├── user-config.nix              # ⭐ YOUR PERSONAL SETTINGS (edit this!)
├── modules/
│   ├── base/                    # Shared config for all hosts
│   ├── home/                    # Noctilia Shell config
│   └── system/                  # Niri system integration
├── hosts/
│   ├── home/                    # Laptop config (bluetooth, battery)
│   └── work/                    # Desktop config
└── home/                        # User packages and settings
```

### Configuration Points

**Personal settings**: `user-config.nix` ⭐ **Edit this first!** (username, timezone, location, etc.)

**System-wide changes**: `modules/base/default.nix` (applies to all hosts)

**Host-specific**: `hosts/{hostname}/configuration.nix` (overrides for single machine)

**User interface**: `modules/home/noctilia.nix` (Noctilia appearance - advanced)

**User apps**: `home/default.nix` (packages and home-manager settings)

## 🎨 Customization

### Change Theme
Edit `modules/home/noctilia.nix`:
```nix
colorSchemes.predefinedScheme = "Ayu";  # or "Catppuccin", "TokyoNight", etc.
```

### Change Wallpapers
Place images in `~/Pictures/Wallpapers/` and they'll rotate automatically (or set `automationEnabled = false` for static).

### Add Packages
Edit `home/default.nix` and add to `home.packages`:
```nix
home.packages = with pkgs; [
  your-package-here
];
```

### Change Power Profile
Default is `powersaver`. To change, edit `modules/home/noctilia.nix`:
```nix
startup = "noctalia-shell ipc call powerProfile set performance";
```

## 🚀 Adding Another Machine

1. Clone repo on new machine
2. Generate hardware config: `sudo nixos-generate-config --show-hardware-config > /tmp/hw.nix`
3. Create `hosts/newhost/` directory
4. Copy hardware config there
5. Create `hosts/newhost/configuration.nix` (use `hosts/work` as template)
6. Add to `flake.nix`:
```nix
nixosConfigurations = {
  newhost = mkHost "newhost" [];
};
```
7. Deploy: `sudo nixos-rebuild switch --flake .#newhost`

## 🔄 Updating

### Pull Latest Changes from GitHub

When there are new updates to the config, run these commands:

```bash
cd ~/nixos-config
```

```bash
git pull
```

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#work
```

> **Tip:** Replace `#work` with `#home` if you're on a laptop.

---

### Update System Packages

This updates NixOS packages, Niri, and Noctilia to their latest versions:

```bash
cd ~/nixos-config
```

```bash
nix flake update
```

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#work
```

---

### Rollback if Something Breaks

```bash
sudo nixos-rebuild switch --rollback
```

Or select a previous generation from the boot menu.

## 🔧 Features

- ✅ TTY auto-login to Niri (no display manager overhead)
- ✅ Wayland-native (no X11)
- ✅ XDG portals configured (screen sharing works)
- ✅ PipeWire audio
- ✅ Power management (battery, power profiles)
- ✅ Bluetooth support (on laptop)
- ✅ Calendar and weather integration
- ✅ Tailscale VPN
- ✅ Firefox with Wayland
- ✅ Automatic Nix store optimization
- ✅ Weekly garbage collection

## 🤝 Contributing

Found a bug or want to improve something? PRs welcome!

## 📝 License

MIT License - feel free to use and modify.

## 🙏 Credits

- [Niri](https://github.com/YaLTeR/niri) - Scrollable-tiling Wayland compositor
- [Noctilia Shell](https://github.com/noctalia-dev/noctalia-shell) - Beautiful desktop shell
- [NixOS](https://nixos.org/) - Declarative Linux distribution

---

**Enjoy your beautiful, fast, and reproducible desktop! ⭐**
