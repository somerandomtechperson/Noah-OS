# NoahOS package updates

**Status:** infrastructure design in progress. This is not enabled in the current 0.1.0 ISO.

## Goal

A NoahOS installation should receive normal software and NoahOS-maintained component updates without downloading and reinstalling a new ISO for every release.

NoahOS is based on Arch Linux, so the intended update mechanism is pacman:

```bash
sudo pacman -Syu
```

This performs a full system upgrade. NoahOS must not instruct users to perform partial upgrades such as upgrading one package with `pacman -Sy package`.

## Repository model

NoahOS will maintain a small custom package repository containing only packages maintained by this project. The standard Arch Linux repositories remain responsible for the underlying Arch packages and their updates.

The custom repository is planned at:

`https://somerandomtechperson.github.io/Noah-OS/repo/$arch`

The initial target architecture is `x86_64`. Repository metadata and package archives will be published below `website/repo/x86_64/`; the existing Pages workflow publishes the full `website/` directory.

GitHub Pages has a published 1 GB site-size limit and a soft 100 GB/month bandwidth limit. This is suitable only while the NoahOS-specific packages remain small. Repository size and download volume must be monitored, with a move to dedicated package hosting if they grow beyond those limits.

## Package boundaries

The first packages should separate NoahOS-owned components from the Arch base:

- **noahos-keyring** — the public signing key and pacman trust data. The private signing key must never be placed in the Git repository or CI logs.
- **noahos-branding** — NoahOS-owned branding assets and system-wide desktop appearance files.
- **noahos-welcome** — NoahOS Welcome Center content and related integration.
- **noahos-release** — release identification and version metadata, once its ownership of the relevant files is settled.

These names are a proposed split, not packages that exist yet. Third-party themes and artwork must retain their own notices and licensing; they should not be repackaged until redistribution terms and the existing `THIRD-PARTY-NOTICES.md` have been checked.

## Signing and trust

Packages and the repository database must be signed with a dedicated NoahOS OpenPGP key. The private key should be generated and kept under maintainer control, preferably offline. Only the public key and its verified full fingerprint are distributed.

The intended policy is to require signatures for both packages and repository databases, using pacman's normal trusted-key checks. Do not use `TrustAll` or disable signature checking.

Existing 0.1.0 installations do not already trust a NoahOS signing key. They will need a documented one-time trust/bootstrap step that asks users to verify the full fingerprint through an independently published NoahOS release channel before adding the key. New installation media should include the verified keyring package so new installations do not need that manual step.

## Existing user settings

Files under `/etc/skel` are defaults for newly created accounts; changing them does not update an existing user's home directory. Package updates must not silently overwrite user-customized Plasma settings.

System-wide assets can be updated by packages. Changes to existing user configuration require an explicit, versioned migration that preserves user changes and has a safe backup or rollback path.

## Rollout

1. **Foundation:** settle package boundaries, create the signing key, create PKGBUILDs, and test a local signed repository.
2. **0.2.0 install path:** include the public keyring and repository configuration in the installed system, not just the live session. Verify the installer creates a persistent user and bootable installation.
3. **Existing 0.1.0 installations:** publish a carefully documented one-time repository/key bootstrap. After that, normal full upgrades can deliver NoahOS packages.
4. **Later:** add a graphical update experience only after the pacman backend, signing, rollback behavior, and update notifications have been tested.

## References

- [Arch package guidelines](https://wiki.archlinux.org/title/Arch_package_guidelines)
- [Creating packages](https://wiki.archlinux.org/title/Creating_packages)
- [pacman.conf(5): custom repositories and signature policy](https://man.archlinux.org/man/pacman.conf.5.en)
- [repo-add(8)](https://man.archlinux.org/man/repo-add.8)
- [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)
