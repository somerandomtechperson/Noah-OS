# NoahOS packages

This directory will contain PKGBUILDs for packages maintained by NoahOS.

The custom repository is intentionally separate from Arch Linux's official repositories. It should contain only NoahOS-maintained packages; Arch's normal repositories continue to provide and update the base operating system.

## Planned initial packages

| Package | Responsibility | Status |
|---|---|---|
| `noahos-keyring` | Public signing key and pacman trust data | Planned; requires maintainer key generation |
| `noahos-branding` | NoahOS-owned visual assets and system-wide appearance files | Planned; asset/licence review required |
| `noahos-welcome` | NoahOS Welcome Center page and integration | Planned; reconcile local profile changes first |
| `noahos-release` | Release metadata | Planned; file ownership not yet defined |

Do not add a package until its file list, dependencies, licensing, upgrade behavior, and ownership of configuration files have been reviewed.

## Build and signing policy

- Build packages as an unprivileged user with `makepkg`.
- Use a dedicated NoahOS signing key.
- Keep the private key out of Git, package build directories, and GitHub Actions.
- Sign each package and the repository database.
- Verify signatures before publishing.
- Increment `pkgrel` when rebuilding the same upstream/project version.
- Never use pacman's `TrustAll` setting.

See [the update infrastructure plan](../docs/updates.md) for the rollout and trust/bootstrap design.

## Repository publication

The initial static repository path is `website/repo/x86_64/`. Use `bash scripts/repository/publish.sh package.pkg.tar.zst` after the signing key and a package have been prepared. The script writes signed repository artifacts locally; review the output before committing and pushing it so the Pages workflow can publish it.

The script has not yet been tested against a real NoahOS signing key or package. Do not use it for a public release until it has passed that test.
