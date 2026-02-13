# GNOME Windows 11 + NixOS

**A modern NixOS desktop configuration with GNOME styled to look and feel like Windows 11.**

[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg)](https://nixos.org/)
[![GNOME](https://img.shields.io/badge/Desktop-GNOME-4A86CF.svg)](https://www.gnome.org/)
[![Windows 11 Style](https://img.shields.io/badge/Theme-Windows%2011-0078D4.svg)](#)

## ✨ Features

- **🎨 Windows 11 Look**: Fluent theme, bottom taskbar, Start menu, blur effects
- **🪟 GNOME Desktop**: Full-featured desktop environment with GDM
- **⚡ Blazing Fast**: zram swap, tmpfs caching, optimized VM settings
- ** Reproducible**: NixOS flakes ensure identical setups across machines
- **🧩 DRY Architecture**: Shared base config, host-specific overrides only
- **⚙️ Easy Customization**: Single `user-config.nix` file for personal settings

## 🎥 What You Get

### Windows 11 Style GNOME
- Bottom taskbar with centered app icons (Dash to Panel)
- Windows 11 Start Menu with search and pinned apps (ArcMenu)
- Acrylic/Mica blur effects on panel and overview (Blur My Shell)
- Rounded window corners (12px radius)
- Fluent-Dark GTK theme + Fluent icon theme + Bibata cursor
- Dark mode throughout, night light enabled
- Minimize/Maximize/Close buttons on the right
- Edge tiling (snap windows to edges)
- System tray with app indicators
- Clipboard history (like Win+V)

### Performance Optimizations
- **zram**: 30% RAM compressed swap
- **tmpfs**: 1.5GB in-memory cache
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

✅ **Done!** After reboot, GDM will greet you with a login screen. Log in and enjoy your Windows 11-style GNOME desktop.

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Super+T` | Terminal (Kitty) |
| `Super+B` | Browser (Google Chrome) |
| `Super+W` | Windsurf |
| `Super+E` | File Manager (Nautilus) |
| `Super+F` | File Manager (Nautilus) |
| `Super+D` | Show Desktop |
| `Super+Q` / `Alt+F4` | Close window |
| `Alt+Tab` | Switch windows |
| `Super+Up` | Toggle maximize |
| `Super+1-4` | Switch workspace |
| `Super+Shift+1-4` | Move window to workspace |

See `home/default.nix` for complete list.

## 📂 Structure

```
├── flake.nix                    # Flake configuration
├── user-config.nix              # ⭐ YOUR PERSONAL SETTINGS (edit this!)
├── modules/
│   ├── base/                    # Shared config for all hosts
│   └── system/                  # GNOME desktop + extensions
├── hosts/
│   ├── home/                    # Laptop config (bluetooth, battery)
│   └── work/                    # Desktop config
└── home/                        # User packages, GNOME dconf settings
```

### Configuration Points

**Personal settings**: `user-config.nix` ⭐ **Edit this first!** (username, timezone, location, etc.)

**System-wide changes**: `modules/base/default.nix` (applies to all hosts)

**Host-specific**: `hosts/{hostname}/configuration.nix` (overrides for single machine)

**GNOME system config**: `modules/system/gnome.nix` (extensions, themes, excluded packages)

**User apps + GNOME dconf**: `home/default.nix` (packages, Win11 dconf settings, keybindings)

## 🎨 Customization

### Change Theme
Edit `home/default.nix` GTK section and dconf `org/gnome/desktop/interface`:
```nix
gtk.theme.name = "Fluent-Dark";  # Change GTK theme
```

### Change Wallpapers
Edit the wallpaper paths in `home/default.nix` under `org/gnome/desktop/background`.

### Add Packages
Edit `home/default.nix` and add to `home.packages`:
```nix
home.packages = with pkgs; [
  your-package-here
];
```

### Add/Remove GNOME Extensions
Edit `modules/system/gnome.nix` to install extensions, then enable them in `home/default.nix` under `dconf.settings."org/gnome/shell".enabled-extensions`.

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

This updates NixOS packages and GNOME extensions to their latest versions:

```bash
cd ~/nixos-config
```

```bash
nix flake update
```

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#work
```

> **Note:** If you get a "Permission denied" error on `flake.lock`, fix ownership with:
> ```bash
> sudo chown -R $USER:users ~/nixos-config
> ```

---

### Rollback if Something Breaks

```bash
sudo nixos-rebuild switch --rollback
```

Or select a previous generation from the boot menu.

## 🔧 Features

- ✅ GNOME desktop with GDM display manager
- ✅ Windows 11-style UI (taskbar, start menu, blur, rounded corners)
- ✅ Wayland-native with XDG portals
- ✅ PipeWire audio
- ✅ Power management (battery, power profiles)
- ✅ Bluetooth support (on laptop)
- ✅ Night light (automatic color temperature)
- ✅ Tailscale VPN
- ✅ Firefox with Wayland
- ✅ Automatic Nix store optimization
- ✅ Weekly garbage collection

## 🤝 Contributing

Found a bug or want to improve something? PRs welcome!

## 📝 License

MIT License - feel free to use and modify.

## 🙏 Credits

- [GNOME](https://www.gnome.org/) - Desktop environment
- [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/) - Windows-style taskbar
- [ArcMenu](https://extensions.gnome.org/extension/3628/arcmenu/) - Windows 11 start menu
- [Fluent GTK Theme](https://github.com/vinceliuice/Fluent-gtk-theme) - Windows 11-style theme
- [NixOS](https://nixos.org/) - Declarative Linux distribution

---

**Enjoy your beautiful, fast, and reproducible desktop! ⭐**
