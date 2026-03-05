# AIY Voice Kit: V1 Setup + Legacy V2 Driver Source

This repository contains out-of-tree Linux kernel modules for the **Google AIY Voice Bonnet v2** stack.

Your hardware is **AIY Voice HAT v1** (`Google AIY audioHAT Board v1`). For V1, you should use the in-kernel Voice HAT overlay and ALSA stack, not the v2 modules in this repo.

## Identify Your Board

Run:

```bash
sudo tr -d '\0' </proc/device-tree/hat/product; echo
```

If it prints:

- `Google AIY audioHAT Board v1`

then use the V1 setup below.

## V1 (audioHAT) Setup

### 1) Enable the correct overlay

Edit boot config:

- Raspberry Pi OS Bookworm: `/boot/firmware/config.txt`
- Older Raspberry Pi OS / some DietPi setups: `/boot/config.txt`

Use:

```ini
dtparam=i2s=on
dtoverlay=googlevoicehat-soundcard
```

If present, remove conflicting AIY v2 lines such as:

- `dtoverlay=aiy-voicebonnet`
- `dtoverlay=aiy-io-voice`
- `dtoverlay=aiy-leds-voice`

Reboot after editing.

### 2) Verify audio devices

```bash
aplay -l
arecord -l
lsmod | grep -Ei 'snd|voicehat|googlevoicehat'
```

Quick playback test:

```bash
speaker-test -c 2 -t wav -l 1
```

Quick mic loopback test:

```bash
arecord -f S16_LE -c1 -r16000 -d3 /tmp/voicehat-test.wav
aplay /tmp/voicehat-test.wav
```

## Volume Control (non-root)

If `alsamixer` shows `cannot open mixer: Permission denied`, your user is usually missing `audio` group membership.

```bash
sudo usermod -aG audio $USER
```

Then log out and log in again (or reboot), and run:

```bash
alsamixer
```

Press `F6` in `alsamixer` and pick the Voice HAT card.

Non-interactive example:

```bash
amixer -c 0 sset 'Master' 75%
```

(Exact control names can vary by kernel image/card profile.)

## Repository Origin

- Upstream fork source: `https://github.com/kobayutapon/aiy-voicekit-drivers`
- Original lineage: Google AIY DKMS packaging (`aiyprojects-raspbian`)

## What This Repo Is For

This repo is useful if you are intentionally building the **legacy Voice Bonnet v2** module stack on newer kernels.

Modules included:

- `aiy/`: `aiy-io-i2c`, `gpio-aiy-io`, `pwm-aiy-io`, `aiy-adc`
- `sound/`: `snd-aiy-voicebonnet`, `rt5645`, `rl6231`
- `leds/`: `leds-ktd202x`

## Legacy V2 Build Commands

From repo root:

```bash
make
make clean
sudo make install
```

`make clean` removes build artifacts from all module directories.

## Compatibility Summary

- **Voice HAT v1 (`audioHAT Board v1`)**: use `googlevoicehat-soundcard` overlay (recommended path).
- **Voice Bonnet v2**: use this repo only if you need out-of-tree v2 modules.

## License

GPL v2 (see `LICENSE`).

## LED Helper (`ledctl`)

For Voice HAT v1 button LED control, this repo includes a helper script:

```bash
./ledctl on --duration 5
./ledctl blink --duration 10
./ledctl pulse --duration 10
./ledctl off
```

By default (without `--duration`) it runs until `Ctrl-C`.

Prerequisites:

```bash
sudo usermod -aG gpio $USER
python3 -m pip install --user --no-deps --break-system-packages \
  git+https://github.com/google/aiyprojects-raspbian.git@aiyprojects
```

After changing groups, start a new login session (or run `newgrp gpio`).
