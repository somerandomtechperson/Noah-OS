#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BUILD_ID="$(date +%Y%m%d-%H%M%S)"
export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-$(date +%s)}"

WORK_DIR="$ROOT/build/work"
BACKUP_DIR="$ROOT/build/work-backup-$BUILD_ID"

echo "=== Preparing fresh build directory ==="

if [[ -d "$WORK_DIR" ]]; then
    mv -- "$WORK_DIR" "$BACKUP_DIR"
    echo "Previous work directory preserved at:"
    echo "$BACKUP_DIR"
fi

mkdir -p "$WORK_DIR"

echo
echo "=== Generating NoahOS build metadata ==="
python infrastructure/releases/generate-build-metadata.py

echo
echo "=== Building NoahOS ISO ==="
sudo env SOURCE_DATE_EPOCH="$SOURCE_DATE_EPOCH" \
    mkarchiso -v \
    -w "$WORK_DIR" \
    -o "$ROOT/build/out" \
    "$ROOT/iso/profile"
