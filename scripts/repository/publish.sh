#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
signing_key="${NOAHOS_SIGNING_KEY:-}"

usage() {
    printf 'Usage: NOAHOS_SIGNING_KEY=<full-key-fingerprint-or-key-id> bash %s <package.pkg.tar.zst> [package.pkg.tar.zst ...]\n' "$0" >&2
    exit 2
}

if [[ "$EUID" -eq 0 ]]; then
    printf 'Do not run this script as root. Sign and prepare repository files as your normal user.\n' >&2
    exit 1
fi

[[ -n "$signing_key" ]] || {
    printf 'NOAHOS_SIGNING_KEY is not set. Use the dedicated NoahOS repository signing key.\n' >&2
    exit 1
}

[[ "$#" -gt 0 ]] || usage

for command in gpg repo-add install realpath; do
    command -v "$command" >/dev/null 2>&1 || {
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    }
done

if ! gpg --batch --list-secret-keys "$signing_key" >/dev/null 2>&1; then
    printf 'No secret key matching %s is available in the current GPG keyring.\n' "$signing_key" >&2
    exit 1
fi

repo_dir="$repo_root/website/repo/x86_64"
db_path="$repo_dir/noahos.db.tar.zst"
mkdir -p -- "$repo_dir"

packages=()

for input_package in "$@"; do
    [[ -f "$input_package" ]] || {
        printf 'Package file not found: %s\n' "$input_package" >&2
        exit 1
    }

    package_name="$(basename -- "$input_package")"
    [[ "$package_name" == *.pkg.tar.zst ]] || {
        printf 'Unsupported package format (expected .pkg.tar.zst): %s\n' "$package_name" >&2
        exit 1
    }

    source_path="$(realpath -- "$input_package")"
    destination_path="$repo_dir/$package_name"

    if [[ "$source_path" != "$destination_path" ]]; then
        install -m 0644 -- "$source_path" "$destination_path"
    fi

    gpg --yes --local-user "$signing_key" --detach-sign \
        --output "$destination_path.sig" "$destination_path"
    packages+=("$destination_path")
done

repo-add --sign --key "$signing_key" "$db_path" "${packages[@]}"

gpg --verify "$db_path.sig" "$db_path" >/dev/null
for package in "${packages[@]}"; do
    gpg --verify "$package.sig" "$package" >/dev/null
done

printf '\nRepository metadata and package signatures verified.\n'
printf 'Repository directory: %s\n' "$repo_dir"
printf 'Review the generated files before committing them to the Pages source branch.\n'
