# Building NoahOS

This page is for contributors working from the NoahOS source repository. Building an ISO requires a compatible Arch Linux build environment and elevated privileges for Archiso operations.

## Requirements

- A current Arch Linux environment.
- Git and Python 3.
- Archiso and its required dependencies.
- Sufficient free disk space for the working directory and generated ISO.
- Administrator privileges for the image build steps.

The exact dependency set can change. Check the profile and build script in the repository before building.

## Get the source

```bash
git clone https://github.com/somerandomtechperson/Noah-OS.git
cd Noah-OS
```

## Build

The project provides a build helper:

```bash
./infrastructure/build-iso.sh
```

The script prepares a fresh build work directory, preserves an existing work directory as a backup, generates build metadata, and invokes `mkarchiso` against `iso/profile`.

The output is written under `build/out/`. The script uses the current time for `SOURCE_DATE_EPOCH` unless that variable is already set in the environment.

## Build profile

The Archiso profile is maintained under `iso/profile/`. Review the profile definition, package list, boot configuration, and airootfs customizations before changing the image.

## Before publishing

1. Confirm the ISO builds successfully from a clean work directory.
2. Boot-test it in a virtual machine.
3. Test on physical hardware where possible.
4. Verify the live session and important hardware functions.
5. Generate and verify checksums.
6. Ensure release metadata matches the actual artifact.
7. Document known issues and limitations.

Never publish an image as tested on hardware or configurations that were not actually tested.
