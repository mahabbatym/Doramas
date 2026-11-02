# DoramaNest REST endpoints

The client builds `${SUPABASE_URL}/rest/v1/<table>` URLs. Every request sends
`apikey: <SUPABASE_ANON_KEY>` and `Authorization: Bearer <user JWT>` (the anon
key is used as the bearer only if no session token exists). Requests time out
after 10 seconds. All writes request returned rows when the caller needs IDs.

| Method | URL / query parameters | Request body | Response | Purpose and caller |
| --- | --- | --- | --- | --- |
| GET | `/dramas?select=*,drama_translations(*),drama_genres(genre_id,genres(id,slug,genre_translations(locale,name))),episodes(id)&order=created_at.desc&limit=100&offset=0` | — | Array of dramas with translations, localized genres and episode IDs | Initial catalog refresh; `SupabaseDramaRepository.fetchCatalog` |
| GET | `/genres?select=id,slug,genre_translations(locale,name)` | — | Array of genre IDs and translations | Resolve the selected genre before saving; admin form submit |
| GET | `/episodes?select=id,number&drama_id=eq.<uuid>&order=number.asc` | — | Array of existing episode rows | Preserve existing episode IDs and video links during update |
| GET | `/profiles?select=is_admin&id=eq.<user-uuid>&limit=1` | — | Zero or one profile row | Decide whether admin controls can be shown |
| GET | `/favorites?select=drama_id&order=created_at.desc&limit=1000` | — | Current user's favorite drama IDs (RLS filtered) | Populate Favorites on startup |
| POST | `/dramas` | `{country, release_year, status, rating, poster_url, backdrop_url}` | Array containing the inserted row and generated UUID | Create a drama; admin form |
| POST | `/drama_translations?on_conflict=drama_id,locale` | `{drama_id, locale, title, description}` with `Prefer: resolution=merge-duplicates,return=representation` | Array containing the saved translation | Add or replace a translation for kk, ru or en |
| PATCH | `/dramas?id=eq.<uuid>` | `{country, release_year, status, rating, poster_url, backdrop_url}` | Array containing the changed row | Update catalog fields; admin form |
| POST | `/drama_genres` | `{drama_id, genre_id}` | Array containing the relation row | Attach the selected genre after replacing old links |
| DELETE | `/drama_genres?drama_id=eq.<uuid>` | — | Empty response | Remove old genre relations before an admin update |
| POST | `/episodes` | Array of `{drama_id, number, youtube_video_id, thumbnail_url, duration_seconds}` | Array containing created rows and UUIDs | Add missing numbered episode rows while preserving existing videos |
| POST | `/episode_translations` | Array of `{episode_id, locale, title}` | Array containing created translations | Localized episode labels for added rows |
| DELETE | `/episodes?drama_id=eq.<uuid>&number=gt.<count>` | — | Empty response | Remove episodes beyond an updated episode count |
| DELETE | `/dramas?id=eq.<uuid>` | — | Empty response | Delete a drama; foreign-key cascades remove translations, genres, cast and episodes |
| POST | `/favorites` | `{user_id, drama_id}` with `Prefer: resolution=merge-duplicates,return=minimal` | Empty response | Add a favorite; card/detail action |
| DELETE | `/favorites?user_id=eq.<user-uuid>&drama_id=eq.<uuid>` | — | Empty response | Remove a favorite; card/detail action |

Local title search, combined catalog filters and sorting operate on the fetched
catalog in memory. A successful catalog GET is cached in SharedPreferences and
mirrored into the existing SQLite database for offline use and watch progress.

## How it works

1. A screen calls `AppController`, which owns loading, errors and current rows.
2. `AppController` delegates catalog CRUD to `SupabaseDramaRepository`.
3. The repository maps records and decides which PostgREST operation to run.
4. `ApiClient` builds the URL, adds key/JWT headers, times out and maps errors.
5. PostgREST applies database constraints and RLS before returning JSON rows.
