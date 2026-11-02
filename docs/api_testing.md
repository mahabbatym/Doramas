# REST operation test guide

Run the app with `env.json`, enable anonymous sign-in and promote the current
anonymous user's profile as described in `supabase/README.md`. Replace the shell
variables below with the project URL, public anon key, a current user's JWT and
UUIDs copied from Table Editor. These examples use only the public key and a
user JWT.

```sh
export SUPABASE_URL='https://your-project-id.supabase.co'
export SUPABASE_ANON_KEY='your-public-anon-key'
export USER_JWT='current-user-access-token'
export USER_ID='current-user-uuid'
export DRAMA_ID='a-drama-uuid'
```

## GET: list dramas

```sh
curl --fail-with-body "$SUPABASE_URL/rest/v1/dramas?select=id,country,release_year,rating,drama_translations(locale,title)&order=created_at.desc&limit=20" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $USER_JWT"
```

Expected: HTTP 200 and a JSON array. In DoramaNest, open Catalog; the fetched
rows replace the demo catalog and appear in the home, search and detail screens.

## POST: create a drama

```sh
curl --fail-with-body -X POST "$SUPABASE_URL/rest/v1/dramas" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $USER_JWT" \
  -H 'Content-Type: application/json' \
  -H 'Prefer: return=representation' \
  -d '{"country":"KR","release_year":2025,"status":"announced","rating":0,"poster_url":null,"backdrop_url":null}'
```

Expected: HTTP 201 and the inserted row, including its generated UUID. Add at
least one `drama_translations` row before showing a title in the app. In the app,
use Catalog → Add drama as an admin; complete the kk/ru/en titles and descriptions.

## PATCH: update that drama

```sh
curl --fail-with-body -X PATCH "$SUPABASE_URL/rest/v1/dramas?id=eq.$DRAMA_ID" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $USER_JWT" \
  -H 'Content-Type: application/json' \
  -H 'Prefer: return=representation' \
  -d '{"status":"completed","rating":8.7}'
```

Expected: HTTP 200 and one changed row. Reopen/refresh the detail screen and
check the updated rating and status-backed data.

## DELETE: remove that drama

```sh
curl --fail-with-body -X DELETE "$SUPABASE_URL/rest/v1/dramas?id=eq.$DRAMA_ID" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $USER_JWT" \
  -H 'Prefer: return=minimal'
```

Expected: HTTP 204. Its translations, genre relations, cast and episodes are
cascaded by foreign keys. Refresh Catalog and confirm the row disappears.

## Favorites POST and DELETE

Add a favorite while signed in:

```sh
curl --fail-with-body -X POST "$SUPABASE_URL/rest/v1/favorites" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $USER_JWT" \
  -H 'Content-Type: application/json' \
  -H 'Prefer: resolution=merge-duplicates,return=minimal' \
  -d "{\"user_id\":\"$USER_ID\",\"drama_id\":\"$DRAMA_ID\"}"
```

Remove it with:

```sh
curl --fail-with-body -X DELETE "$SUPABASE_URL/rest/v1/favorites?user_id=eq.$USER_ID&drama_id=eq.$DRAMA_ID" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $USER_JWT"
```

Expected: the Favorites tab updates after either action and the selection remains
after restarting the app. RLS must reject a request that uses another user's ID.

## In-app verification and screenshots

1. Start with valid keys and confirm the server catalog loads.
2. Open a drama detail and favorite it; check Favorites, then remove it from the
   card and confirm both screens agree.
3. As an admin, create a row, edit its title/rating, and delete it. Refresh after
   each operation and confirm the visible catalog matches Table Editor.
4. As a non-admin, confirm add/edit/delete controls are hidden and RLS rejects a
   direct write.
5. Enable airplane mode after one successful load; confirm saved rows remain
   visible with the offline banner. Restore connectivity and confirm retry loads
   server rows again.
6. Capture catalog GET, admin create, edit, delete, favorite add/remove, offline
   banner, and the updated UI after each operation.

The curl procedures are provided for the practical defense. No live Supabase
project or test device is configured in this workspace, so the requests above
remain to be run against a student's project.
