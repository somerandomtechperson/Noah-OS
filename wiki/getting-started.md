# Getting started

This guide covers obtaining a NoahOS image and preparing bootable media.

## 1. Check the release information

Open the [NoahOS releases page](https://github.com/somerandomtechperson/Noah-OS/releases) or the [download page](https://somerandomtechperson.github.io/Noah-OS/download.html). Read the release notes and confirm that the image is intended for your hardware.

NoahOS development images target 64-bit x86 computers (x86_64).

## 2. Download all required files

Some published images may be split into multiple parts to fit hosting limits. If a release includes split parts, download every part and its checksum file. Keep them together in one folder and do not rename the parts unless the release instructions say to.

## 3. Reconstruct a split image

On Linux, from the folder containing the parts:

```bash
cat noahos-*.iso.part.* > noahos-reconstructed.iso
```

On Windows Command Prompt, use the exact filenames shown on the release page:

```bat
copy /b part.01+part.02 noahos-reconstructed.iso
```

The Windows example is illustrative: replace the part names with the actual names from the release and include every part in the correct order.

## 4. Verify the image

Use the checksum file published with that exact release. On Linux:

```bash
sha256sum -c noahos-<release>.iso.sha256
```

On Windows PowerShell:

```powershell
Get-FileHash .\noahos-<release>.iso -Algorithm SHA256
```

Compare the result with the SHA256 value published by the release. Do not use a checksum from a different build.

## 5. Write the image to USB

Use a trusted image-writing utility such as Rufus on Windows or KDE ISO Image Writer on Linux.

1. Connect the USB drive.
2. Select the NoahOS ISO.
3. Carefully verify that the selected destination is the intended USB drive.
4. Start writing and wait for the utility to finish.

**Warning:** Writing an ISO erases the selected USB drive. Back up its contents first and double-check the target device.

## 6. Boot from USB

Restart the computer and open its firmware boot menu. Select the USB device. NoahOS currently includes UEFI and legacy BIOS boot support in its Archiso profile; the available choice depends on the computer.

See [Live environment](live-environment.md) after startup.
