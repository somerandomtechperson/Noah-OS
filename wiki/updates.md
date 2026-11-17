# Updates

NoahOS is a rolling-development project built on Arch Linux. Its update tooling is being developed in stages.

## Package update checking

The repository includes a NoahOS update-agent package. Its current checker uses Arch's `checkupdates` utility from `pacman-contrib` to check whether repository package updates are available. The checker records status for the system update experience.

A notification that updates are available is not the same as installing them. Review the package manager output and release guidance before making system changes.

## Update experience

A more integrated update experience in System Settings has been a project goal. Treat graphical update controls, release metadata presentation, and automatic installation as works in progress unless they are explicitly documented in the build you are using.

## General precautions

- Back up important data before system upgrades.
- Read release notes for known issues.
- Do not interrupt package transactions.
- Use package sources and signing configuration supplied by the project.
- If an update fails, record the full error output and report it through the [issue tracker](https://github.com/somerandomtechperson/Noah-OS/issues).

## Development references

The implementation lives under `infrastructure/packages/noahos-update-agent/` and release metadata is maintained under `infrastructure/releases/` in the source repository. These paths may change as development continues.
