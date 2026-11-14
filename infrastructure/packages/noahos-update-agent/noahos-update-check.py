#!/usr/bin/env python3

import datetime
import json
import re
import shutil
import subprocess
import sys


def output(data):
    print(json.dumps(data, indent=2))


def main():
    checker = shutil.which("checkupdates")

    if not checker:
        output({
            "schema_version": 1,
            "status": "error",
            "error": "checkupdates is not installed"
        })
        return 1

    try:
        result = subprocess.run(
            [checker, "--nocolor"],
            capture_output=True,
            text=True,
            timeout=1800
        )
    except subprocess.TimeoutExpired:
        output({
            "schema_version": 1,
            "status": "error",
            "error": "Update check timed out"
        })
        return 1
    except OSError as error:
        output({
            "schema_version": 1,
            "status": "error",
            "error": str(error)
        })
        return 1

    if result.returncode not in (0, 2):
        output({
            "schema_version": 1,
            "status": "error",
            "error": result.stderr.strip() or
                     f"checkupdates exited with code {result.returncode}"
        })
        return 1

    updates = []

    for line in result.stdout.splitlines():
        line = line.strip()

        if not line:
            continue

        match = re.fullmatch(r"(\S+)\s+(\S+)\s+->\s+(\S+)", line)

        if not match:
            output({
                "schema_version": 1,
                "status": "error",
                "error": f"Unrecognized checkupdates output: {line}"
            })
            return 1

        name, current, available = match.groups()

        updates.append({
            "name": name,
            "current_version": current,
            "available_version": available
        })

    checked_at = (
        datetime.datetime.now(datetime.timezone.utc)
        .isoformat(timespec="seconds")
        .replace("+00:00", "Z")
    )

    output({
        "schema_version": 1,
        "checked_at": checked_at,
        "source": "pacman",
        "status": "updates_available" if updates else "up_to_date",
        "update_count": len(updates),
        "download_size_bytes": None,
        "updates": updates
    })

    return 0


if __name__ == "__main__":
    sys.exit(main())
