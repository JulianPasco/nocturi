# COSMIC Desktop + NixOS

**A modern NixOS desktop configuration with the COSMIC desktop environment.**

[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg)](https://nixos.org/)
[![COSMIC](https://img.shields.io/badge/Desktop-COSMIC-orange.svg)](https://github.com/pop-os/cosmic-epoch)
[![Rust](https://img.shields.io/badge/Built%20with-Rust-orange.svg)](https://www.rust-lang.org/)

## ✨ Features

- **🚀 COSMIC Desktop**: Modern Rust-based desktop built by System76
- **⚡ Blazing Fast**: Native Wayland, GPU-accelerated, zram swap, optimized VM settings
- **🔧 Reproducible**: NixOS flakes ensure identical setups across machines
- **🧩 DRY Architecture**: Shared base config, host-specific overrides only
- **⚙️ Persistent Settings**: COSMIC configuration managed declaratively
- **🎨 Customizable**: Easy theme and appearance configuration

## 🎥 What You Get

### COSMIC Desktop Environment
- **Modern UI**: Clean, responsive interface built in Rust
- **Wayland-native**: Smooth animations and GPU acceleration
- **Tiling & Floating**: Automatic tiling with manual override
- **Panel & Dock**: Customizable panel and application dock
- **App Library**: Application launcher with search
- **Workspaces**: Multiple workspace support
- **Dark Theme**: Beautiful dark theme with customizable accents
- **Bibata Cursors**: Modern cursor theme
- **Settings Persistence**: Your customizations are saved in git

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

✅ **Done!** After reboot, COSMIC Greeter will greet you with a login screen. Log in and enjoy your COSMIC desktop.

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Super` / `Super+/` | Open App Library |
| `Super+T` | Terminal |
| `Super+B` | Browser (Google Chrome) |
| `Super+E` | File Manager |
| `Super+Q` | Close window |
| `Alt+Tab` | Switch windows |
| `Super+Arrow` | Tile window to edge |
| `Super+1-9` | Switch workspace |
| `Super+Shift+1-9` | Move window to workspace |

COSMIC uses intuitive keybindings. Customize them in Settings → Keyboard → Shortcuts.

## 📂 Structure

```
├── flake.nix                    # Flake configuration
├── user-config.nix              # ⭐ YOUR PERSONAL SETTINGS (edit this!)
├── modules/
│   ├── base/                    # Shared config for all hosts
│   └── system/                  # COSMIC desktop configuration
├── hosts/
│   ├── home/                    # Laptop config (bluetooth, battery)
│   └── work/                    # Desktop config
└── home/
    ├── default.nix              # User packages and settings
    └── cosmic-config/           # COSMIC desktop settings (persistent)
```

### Configuration Points

**Personal settings**: `user-config.nix` ⭐ **Edit this first!** (username, timezone, location, etc.)

**System-wide changes**: `modules/base/default.nix` (applies to all hosts)

**Host-specific**: `hosts/{hostname}/configuration.nix` (overrides for single machine)

**COSMIC system config**: `modules/system/cosmic.nix` (desktop environment, portals, services)

**User apps + settings**: `home/default.nix` (packages, GTK theming)

**COSMIC desktop settings**: `home/cosmic-config/cosmic/` (theme, panel, dock, window management)

## 🎨 Customization

### Change COSMIC Settings

**Method 1: Use COSMIC Settings App (Recommended)**
1. Open COSMIC Settings from the app library
2. Customize appearance, panel, dock, behavior, etc.
3. Copy updated config to repository:
   ```bash
   cp -r ~/.config/cosmic ~/nixos-config/home/cosmic-config/
   ```
4. Commit changes:
   ```bash
   cd ~/nixos-config
   git add home/cosmic-config/
   git commit -m "Update COSMIC settings"
   ```

**Method 2: Edit Config Files Directly**

COSMIC uses RON (Rusty Object Notation) files in `home/cosmic-config/cosmic/`. Edit these manually if you prefer.

### Change GTK Theme

Edit `home/default.nix` GTK section:
```nix
gtk = {
  enable = true;
  cursorTheme = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };
};
```

### Add Packages

Edit `home/default.nix` and add to `home.packages`:
```nix
home.packages = with pkgs; [
  your-package-here
];
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

- ✅ COSMIC desktop with COSMIC Greeter
- ✅ Wayland-native compositor with XDG portals
- ✅ PipeWire audio
- ✅ Persistent COSMIC settings (version controlled)
- ✅ Power management (battery, power profiles)
- ✅ Bluetooth support (on laptop)
- ✅ Tailscale VPN
- ✅ GPU-accelerated rendering
- ✅ Automatic Nix store optimization
- ✅ Weekly garbage collection
- ✅ Built-in COSMIC apps (Files, Terminal, Settings, etc.)

## 🤝 Contributing

Found a bug or want to improve something? PRs welcome!

## 📝 License

MIT License - feel free to use and modify.

## 🙏 Credits

- [COSMIC Desktop](https://github.com/pop-os/cosmic-epoch) - Modern Rust-based desktop environment by System76
- [NixOS](https://nixos.org/) - Declarative Linux distribution
- [nixos-cosmic community](https://github.com/lilyinstarlight/nixos-cosmic) - COSMIC integration for NixOS
- [Bibata Cursors](https://github.com/ful1e5/Bibata_Cursor) - Modern cursor theme

---

**Enjoy your beautiful, fast, and reproducible desktop! ⭐**
