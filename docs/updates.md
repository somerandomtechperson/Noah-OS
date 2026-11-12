# NoahOS package updates

**Status:** infrastructure design in progress. This is not enabled in the current 0.1.0 ISO.

## Goal

A NoahOS installation should receive normal software and NoahOS-maintained component updates without downloading and reinstalling a new ISO for every release.

NoahOS is based on Arch Linux, so the intended package transaction is a full pacman system upgrade:

```bash
sudo pacman -Syu
```

This refreshes repository databases and upgrades the installed system together. NoahOS must not perform partial upgrades such as `pacman -Sy package`.

## Repository model

NoahOS will maintain a small custom package repository containing only packages maintained by this project. The standard Arch Linux repositories remain responsible for the underlying Arch packages and their updates.

The custom repository is planned at:

`https://somerandomtechperson.github.io/Noah-OS/repo/$arch`

The initial target architecture is `x86_64`. Repository metadata and package archives will be published below `website/repo/x86_64/`; the existing Pages workflow publishes the full `website/` directory.

GitHub Pages has a published 1 GB site-size limit and a soft 100 GB/month bandwidth limit. This is suitable only while the NoahOS-specific packages remain small. Repository size and download volume must be monitored, with a move to dedicated package hosting if they grow beyond those limits.

## Package boundaries

The first packages should separate NoahOS-owned components from the Arch base:

- **noahos-keyring** — the public signing key and pacman trust data. The private signing key must never be placed in the Git repository or CI logs.
- **noahos-branding** — NoahOS-owned visual assets and system-wide appearance files.
- **noahos-welcome** — NoahOS Welcome Center content and related integration.
- **noahos-release** — release identification and version metadata, once its ownership of the relevant files is settled.

These names are a proposed split, not packages that exist yet. Third-party themes and artwork must retain their own notices and licensing; they should not be repackaged until redistribution terms and the existing `THIRD-PARTY-NOTICES.md` have been checked.

## Signing and trust

Packages and the repository database must be signed with a dedicated NoahOS OpenPGP key. The private key should be generated and kept under maintainer control, preferably offline. Only the public key and its verified full fingerprint are distributed.

The intended policy is to require signatures for both packages and repository databases, using pacman's normal trusted-key checks. Do not use `TrustAll` or disable signature checking.

Existing 0.1.0 installations do not already trust a NoahOS signing key. They will need a documented one-time trust/bootstrap step that asks users to verify the full fingerprint through an independently published NoahOS release channel before adding the key. New installation media should include the verified keyring package so new installations do not need that manual step.

## KDE update interface: important Arch Linux constraint

The Discover package includes KDE's Updates page and a System Settings updates module, but the presence of that interface does not guarantee a safe Arch Linux transaction backend.

Arch's own guidance warns that PackageKit is not recommended for general package management. The stock ALPM PackageKit backend has a database-refresh/installation flow that can conflict with Arch's requirement to perform full upgrades and avoid partial upgrades. Do not enable the stock PackageKit backend for system updates just to make the Updates page appear.

A safer long-term design is:

1. A small, auditable privileged update service owns ALPM transactions and is authorized through polkit.
2. The service checks updates without leaving pacman's sync databases ahead of installed packages.
3. Every system package installation/update uses a full-upgrade-safe transaction.
4. A KDE frontend (ideally a NoahOS System Settings module) displays the update list and invokes that service. It must never run privileged shell strings assembled from UI input.

There is a community ALPM-over-D-Bus/PackageKit project discussed on the Arch mailing list in October 2026, but its announcement describes the available packages as AUR `-git` builds pending an upstream ALPM dependency change. Treat it as a research candidate, not as a production dependency, until its current status and transaction semantics are verified.

The first milestone should be a user-confirmed **Check for updates** and **Install updates** workflow. Background checking and notifications can follow. Do not silently install rolling-release system updates in the background until the transaction policy, interruption handling, recovery, and user-consent design are proven.

## Update details shown to users

The future NoahOS Updates view should distinguish package metadata from NoahOS release metadata:

- Package name, installed version, available version, repository, description, and package download size come from repository metadata.
- Package build date is the package's build timestamp; it is not necessarily the date a NoahOS release was published.
- Total download size is calculated from the packages selected for the transaction.
- A curated NoahOS release record supplies the NoahOS build/release date, version, build identifier, highlights, full release notes, and links.
- A restart-required notice should be shown when the transaction updates components that require a reboot.

A small versioned release manifest (for example, JSON plus Markdown release notes) should be published alongside the package repository. Never infer a NoahOS release date from the build date of an unrelated Arch package.

## Existing user settings

Files under `/etc/skel` are defaults for newly created accounts; changing them does not update an existing user's home directory. Package updates must not silently overwrite user-customized Plasma settings.

System-wide assets can be updated by packages. Changes to existing user configuration require an explicit, versioned migration that preserves user changes and has a safe backup or rollback path.

## Testing plan

1. Build a harmless test package and create a local signed repository.
2. Install the test package in a disposable QEMU guest.
3. Publish a higher package version and confirm the guest sees it during a full system update.
4. Verify package and database signatures, displayed version, download size, build timestamp, and release notes.
5. Test interrupted downloads, failed signature checks, cancelled transactions, and recovery before enabling this for normal systems.
6. Only then connect the frontend and notification system.

Do not test with the host's real system database or production signing keys. Use a disposable VM and a separate test key until the workflow is verified.

## Rollout

1. **Foundation:** settle package boundaries, create the signing key, create PKGBUILDs, and test a local signed repository.
2. **0.2.0 install path:** include the public keyring and repository configuration in the installed system, not just the live session. Verify the installer creates a persistent user and bootable installation.
3. **Existing 0.1.0 installations:** publish a carefully documented one-time repository/key bootstrap. After that, normal full upgrades can deliver NoahOS packages.
4. **Later:** add a graphical update experience only after the ALPM backend, signing, rollback behavior, and update notifications have been tested.

## References

- [Arch package guidelines](https://wiki.archlinux.org/title/Arch_package_guidelines)
- [System maintenance and unsupported partial upgrades](https://wiki.archlinux.org/title/System_maintenance)
- [Creating packages](https://wiki.archlinux.org/title/Creating_packages)
- [pacman.conf(5): custom repositories and signature policy](https://man.archlinux.org/man/pacman.conf.5.en)
- [repo-add(8)](https://man.archlinux.org/man/repo-add.8)
- [Discover package files: PackageKit backend and System Settings KCM](https://archlinux.org/packages/extra/x86_64/discover/files/)
- [Arch mailing-list discussion of ALPM over D-Bus](https://www.mail-archive.com/arch-general%40lists.archlinux.org/msg04497.html)
- [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)
