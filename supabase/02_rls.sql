create or replace function public.is_catalog_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.is_admin = true
  );
$$;
revoke all on function public.is_catalog_admin() from public;
grant execute on function public.is_catalog_admin() to anon, authenticated;

grant select, insert, update, delete on
  public.dramas,
  public.drama_translations,
  public.genres,
  public.genre_translations,
  public.drama_genres,
  public.actors,
  public.actor_translations,
  public.drama_cast,
  public.episodes,
  public.episode_translations
to anon, authenticated;
grant select on public.profiles to authenticated;
grant select, insert, delete on public.favorites to authenticated;

alter table public.dramas enable row level security;
alter table public.drama_translations enable row level security;
alter table public.genres enable row level security;
alter table public.genre_translations enable row level security;
alter table public.drama_genres enable row level security;
alter table public.actors enable row level security;
alter table public.actor_translations enable row level security;
alter table public.drama_cast enable row level security;
alter table public.episodes enable row level security;
alter table public.episode_translations enable row level security;
alter table public.profiles enable row level security;
alter table public.favorites enable row level security;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'dramas', 'drama_translations', 'genres', 'genre_translations',
    'drama_genres', 'actors', 'actor_translations', 'drama_cast',
    'episodes', 'episode_translations'
  ] loop
    execute format('drop policy if exists catalog_public_read on public.%I', table_name);
    execute format('drop policy if exists catalog_admin_insert on public.%I', table_name);
    execute format('drop policy if exists catalog_admin_update on public.%I', table_name);
    execute format('drop policy if exists catalog_admin_delete on public.%I', table_name);
    execute format(
      'create policy catalog_public_read on public.%I for select to anon, authenticated using (true)',
      table_name
    );
    execute format(
      'create policy catalog_admin_insert on public.%I for insert to authenticated with check (public.is_catalog_admin())',
      table_name
    );
    execute format(
      'create policy catalog_admin_update on public.%I for update to authenticated using (public.is_catalog_admin()) with check (public.is_catalog_admin())',
      table_name
    );
    execute format(
      'create policy catalog_admin_delete on public.%I for delete to authenticated using (public.is_catalog_admin())',
      table_name
    );
  end loop;
end;
$$;

drop policy if exists profiles_select_self on public.profiles;
create policy profiles_select_self on public.profiles
for select to authenticated using (id = auth.uid());

drop policy if exists favorites_select_self on public.favorites;
create policy favorites_select_self on public.favorites
for select to authenticated using (user_id = auth.uid());
drop policy if exists favorites_insert_self on public.favorites;
create policy favorites_insert_self on public.favorites
for insert to authenticated with check (user_id = auth.uid());
drop policy if exists favorites_delete_self on public.favorites;
create policy favorites_delete_self on public.favorites
for delete to authenticated using (user_id = auth.uid());
