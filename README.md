# NixOS Configuration with Niri and Noctilia

This is a NixOS configuration using Flakes that sets up:
- Niri window manager (a scrollable-tiling Wayland compositor)
- Noctilia shell (a modern shell/panel)
- Home Manager for user configuration

## Directory Structure

- `flake.nix`: The main flake configuration file with inputs and outputs
- `hosts/`: Machine-specific configurations
  - `home/`: Configuration for home PC (with WiFi and Bluetooth)
  - `work/`: Configuration for work PC (without WiFi)
- `modules/`: Shared configuration modules
  - `system/`: System-wide configuration modules
    - `niri.nix`: Niri window manager configuration
- `home/`: Home Manager user configuration

## Installation

### For the Home PC (current)

1. Clone this repository:
   ```bash
   sudo rm -rf /etc/nixos.bak
   sudo mv /etc/nixos /etc/nixos.bak
   sudo git clone https://github.com/yourusername/nixos-config.git /etc/nixos
   ```

2. Build the system:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#home
   ```

3. Reboot to apply all changes:
   ```bash
   sudo reboot
   ```

### For the Work PC

1. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
   ```

2. Copy the generated hardware configuration:
   ```bash
   sudo cp /tmp/hardware-configuration.nix /etc/nixos/hosts/work/
   ```

3. Build the system:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#work
   ```

## Usage

### Updating Configuration

After making changes to the configuration:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#home  # For home PC
sudo nixos-rebuild switch --flake /etc/nixos#work  # For work PC
```

### Keybindings

The default keybindings for Niri are:

- `Logo+Return`: Open terminal (Kitty)
- `Logo+R`: Open application launcher (Rofi)
- `Logo+Q`: Close window
- `Logo+F`: Toggle fullscreen
- `Logo+E`: Toggle floating
- `Logo+1-9`: Switch to workspace 1-9
- `Logo+Shift+1-9`: Move window to workspace 1-9
- `Logo+h/j/k/l`: Focus window left/down/up/right
- `Logo+Shift+h/j/k/l`: Move window left/down/up/right
- `Logo+Shift+E`: Quit Niri
- `Logo+Shift+R`: Reload configuration

## Customization

### Noctilia Shell

You can customize Noctilia shell by modifying the settings in `/home/julian/nixos-config/home/default.nix`.

### System Packages

Add/remove system packages in the host configuration files (`hosts/home/default.nix` and `hosts/work/default.nix`).

### User Packages

Add/remove user packages in the Home Manager configuration (`home/default.nix`).

## Troubleshooting

If you experience issues with the configuration:

1. Try rebuilding with `--show-trace` to get more information:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#home --show-trace
   ```

2. You can boot into the previous generation from the bootloader if something breaks.

3. If you can't boot at all, you can boot from a NixOS live USB and recover the system.
