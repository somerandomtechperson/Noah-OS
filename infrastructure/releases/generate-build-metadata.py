#!/usr/bin/env python3

import datetime
import json
import os
from pathlib import Path

epoch = int(os.environ.get("SOURCE_DATE_EPOCH", "0"))

if epoch == 0:
    epoch = int(datetime.datetime.now(
        datetime.timezone.utc
    ).timestamp())

build_date = datetime.datetime.fromtimestamp(epoch).astimezone()

metadata = {
    "schema_version": 1,
    "distribution": "NoahOS",
    "channel": "rolling",
    "architecture": "x86_64",
    "build_id": build_date.strftime("%Y.%m.%d"),
    "build_date": build_date.isoformat(timespec="seconds")
}

destination = Path(
    "iso/profile/airootfs/etc/noahos-build"
)

destination.write_text(
    json.dumps(metadata, indent=2) + "\n",
    encoding="utf-8"
)

print(f"Generated NoahOS build metadata: {metadata['build_id']}")
