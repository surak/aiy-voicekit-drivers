# AIY sound module notes

This directory contains out-of-tree ALSA drivers for the **Google AIY Voice Bonnet v2**.

If your board is **Voice HAT v1** (`Google AIY audioHAT Board v1`), do not use these modules. Use the in-kernel `googlevoicehat-soundcard` overlay instead.

`rt5645` and `rl6231` were copied from the Linux kernel codec tree because the symbols needed by `snd-aiy-voicebonnet` are not exported for simple DKMS-style builds.
