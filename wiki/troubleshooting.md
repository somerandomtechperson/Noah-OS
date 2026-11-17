# Troubleshooting

This page collects general first steps for common problems. NoahOS is still experimental, so include the exact build ID and hardware details when reporting an issue.

## The USB drive does not appear in the boot menu

- Recreate the USB using the complete ISO.
- Try another USB port.
- Check the computer's firmware boot menu and USB boot settings.
- If the computer offers separate UEFI and legacy entries, try the mode supported by your hardware.

## The system does not boot

- Verify the SHA256 checksum against the matching release.
- Reconstruct split downloads again if the release uses multiple parts.
- Re-write the image to USB and wait for the writer to finish.
- Test another USB drive or port if available.
- Record any on-screen error messages.

## Black screen or display problems

- Test the same image on another display or computer if practical.
- Check whether the issue occurs in both firmware boot modes, if available.
- Include the graphics hardware model and whether the issue occurs on physical hardware or in a virtual machine.

## Network or package update problems

- Check that the system has a working network connection.
- Record the exact command and complete error output.
- Avoid disabling package signature verification as a workaround.
- Include the build ID and relevant repository configuration when opening an issue.

## Reporting a bug

Open a report in the [NoahOS issue tracker](https://github.com/somerandomtechperson/Noah-OS/issues). Include:

- NoahOS build ID or release name.
- Computer model and relevant hardware.
- Whether the problem occurs on physical hardware or in a VM.
- Steps to reproduce the problem.
- Exact error messages or relevant logs.

Do not post passwords, authentication tokens, private keys, or unredacted network credentials in public issues or screenshots.
