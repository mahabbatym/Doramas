# Supabase setup

The app uses Supabase Auth for anonymous sessions and makes its catalog requests
with explicit `http` calls to the PostgREST REST API. The mobile client only uses
the project URL and the public anon/publishable key. Never put a `service_role`
key in this project.

## Create and configure a project

1. Create a Supabase project and wait for its database to finish provisioning.
2. Open **SQL Editor** and run `01_schema.sql`, then `02_rls.sql`, then
   `03_seed.sql` from this directory.
3. In **Authentication → Providers → Anonymous**, enable anonymous sign-ins.
   The app creates an anonymous user at first launch so favorites have a stable
   owner without showing a login screen.
4. In **Project Settings → API**, copy the Project URL and the public anon key
   (or publishable key). Do not copy the service role/secret key.
5. Copy `env.example.json` to `env.json` in the project root and replace both
   sample values. `env.json` is gitignored.
6. Run the app with:

   ```sh
   flutter run --dart-define-from-file=env.json
   ```

   If the values are missing, DoramaNest displays a setup banner and continues
   with its local SQLite catalog.

## Grant catalog admin access for testing

Launch the app once while anonymous sign-in is enabled. In the Supabase SQL
Editor, promote the newest anonymous user for a CRUD exercise:

```sql
update public.profiles
set is_admin = true
where id = (
  select id
  from auth.users
  where is_anonymous = true
  order by created_at desc
  limit 1
);
```

The profile trigger creates `profiles` rows with `is_admin = false`. The app
reads only the current user's profile. Catalog writes remain protected by RLS;
changing or hiding a UI control does not grant database access.

## Check tables and security

Open **Table Editor** and inspect `dramas`, `drama_translations`, `genres`,
`genre_translations`, `drama_genres`, `actors`, `actor_translations`,
`drama_cast`, `episodes`, `episode_translations`, `profiles`, and `favorites`.
Each table has RLS enabled. Anonymous and signed-in users can read catalog rows;
only authenticated users whose profile is an admin can write catalog rows.
Favorites are limited to the authenticated owner.

The seed includes 42 dramas with kk/ru/en translations. The original 12 entries
have cast and episode rows. Thirty added Korean dramas each have three genre
links, episode-count rows and artwork from official YouTube trailer thumbnails.
Those thumbnails are artwork only; episode video IDs remain null. Actor photos
and episode thumbnails are also left unset. Run
`python3 scripts/check_seed_urls.py` to check each seeded image URL for an HTTP
200 response and an image content type. If a URL fails, replace it before using
the seed with a live project.

Android and iOS are the intended mobile targets. This checkout currently has an
iOS runner but no `android/` runner directory; web and desktop are not verified.
