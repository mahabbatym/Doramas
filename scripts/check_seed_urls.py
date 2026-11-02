#!/usr/bin/env python3
"""Check HTTPS image URLs embedded in supabase/03_seed.sql."""

from __future__ import annotations

import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

SEED = Path(__file__).resolve().parents[1] / "supabase" / "03_seed.sql"
URL_PATTERN = re.compile(r"https://[^\s'\"]+")


def main() -> int:
    urls = sorted(set(URL_PATTERN.findall(SEED.read_text(encoding="utf-8"))))
    if not urls:
        print("No image URLs are seeded yet; add licensed URLs before checking media.")
        return 0

    failures = 0
    for url in urls:
        request = urllib.request.Request(
            url, headers={"User-Agent": "DoramaNest-seed-check/1.0"}
        )
        try:
            with urllib.request.urlopen(request, timeout=10) as response:
                content_type = response.headers.get_content_type()
                ok = response.status == 200 and content_type.startswith("image/")
                print(f"{'OK' if ok else 'FAIL'} {response.status} {content_type} {url}")
                failures += not ok
        except (urllib.error.URLError, TimeoutError) as error:
            print(f"FAIL {url}: {error}")
            failures += 1
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
