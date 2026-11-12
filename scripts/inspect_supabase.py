#!/usr/bin/env python3
"""Read-only public API probe. Never prints credentials or user records."""
import json
import urllib.error
import urllib.request
from pathlib import Path

config = json.loads((Path(__file__).resolve().parents[1] / 'env.json').read_text())
for table in ('dramas', 'drama_translations', 'genres', 'profiles', 'favorites',
              'watch_progress', 'user_preferences', 'reviews', 'review_stats'):
    request = urllib.request.Request(
        config['SUPABASE_URL'].rstrip('/') + '/rest/v1/' + table + '?select=*&limit=0',
        headers={'apikey': config['SUPABASE_ANON_KEY']})
    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            print(table, response.status, 'reachable (no rows requested)')
    except urllib.error.HTTPError as error:
        try:
            body = json.loads(error.read())
            print(table, error.code, body.get('code'), body.get('message'))
        except (ValueError, UnicodeError):
            print(table, error.code)
    except urllib.error.URLError as error:
        print(table, type(error.reason).__name__)
