# Live environment

NoahOS is distributed as a bootable live system. You can start the desktop from USB without installing it to the computer.

## Starting a live session

1. Write the downloaded ISO to a USB drive.
2. Boot the computer from that USB drive.
3. Select the available NoahOS boot entry if a menu appears.
4. Allow the live system to finish starting before interacting with the desktop.

Boot menu names and firmware behavior vary between computers.

## Live-session behavior

The current project configuration is designed for a live desktop. The project has previously documented that the live environment can continue running from memory after the boot media is removed once startup has fully completed. Do not remove the drive during startup; behavior can vary by build and hardware.

## What to expect

- A KDE Plasma desktop customized with NoahOS branding and defaults.
- A selection of applications and system utilities included in the image.
- A development environment whose contents may change between builds.

## Installation

A complete installed-system workflow and graphical installer are still under development. Unless a particular release explicitly includes and documents an installer, use the ISO as a live environment and do not assume that the live session is a permanent installation.

## Saving files

A standard live session should not be treated as persistent storage. Save important work to a separate storage device or another location you control, and verify that it remains available before shutting down.
