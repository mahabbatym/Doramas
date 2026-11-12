-- Additive upgrade for the schema in 01_schema.sql / 02_rls.sql.
-- Review the live schema first. Run once in a transaction with a database owner.
-- No catalog reseeding, user deletion, or destructive table replacement.
begin;

alter table public.profiles add column if not exists nickname text not null default 'DoramaNest';
alter table public.dramas add column if not exists original_title text;
alter table public.favorites add column if not exists is_saved boolean not null default true;
alter table public.favorites add column if not exists updated_at timestamptz not null default now();

-- Extend existing language constraints; preserve all existing translations.
alter table public.drama_translations drop constraint if exists drama_translations_locale_check;
alter table public.drama_translations add constraint drama_translations_locale_check check (locale in ('kk','ru','en','ko'));
alter table public.genre_translations drop constraint if exists genre_translations_locale_check;
alter table public.genre_translations add constraint genre_translations_locale_check check (locale in ('kk','ru','en','ko'));
alter table public.actor_translations drop constraint if exists actor_translations_locale_check;
alter table public.actor_translations add constraint actor_translations_locale_check check (locale in ('kk','ru','en','ko'));
alter table public.episode_translations drop constraint if exists episode_translations_locale_check;
alter table public.episode_translations add constraint episode_translations_locale_check check (locale in ('kk','ru','en','ko'));

create or replace function public.create_profile_for_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles(id, nickname, is_admin)
  values(new.id, left(coalesce(nullif(trim(new.raw_user_meta_data->>'nickname'),''),'DoramaNest'),40), false)
  on conflict(id) do update set nickname = excluded.nickname;
  return new;
end;
$$;
revoke all on function public.create_profile_for_new_user() from public, anon, authenticated;
drop trigger if exists on_auth_user_created_dorama_nest on auth.users;
create trigger on_auth_user_created_dorama_nest after insert or update of raw_user_meta_data on auth.users
for each row execute function public.create_profile_for_new_user();
insert into public.profiles(id,nickname,is_admin)
select id,left(coalesce(nullif(trim(raw_user_meta_data->>'nickname'),''),'DoramaNest'),40),false
from auth.users on conflict(id) do nothing;
-- Do not let users grant themselves administrative privileges.
revoke all on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;

create table if not exists public.watch_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  drama_id uuid not null references public.dramas(id) on delete cascade,
  episodes_watched integer not null default 0 check (episodes_watched >= 0),
  status text not null default 'planned' check (status in ('planned','watching','completed','dropped')),
  updated_at timestamptz not null default now(),
  primary key(user_id,drama_id)
);
create table if not exists public.user_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  genres text[] not null default '{}' check (genres <@ array['romance','comedy','fantasy','music','drama','mystery','family','action','thriller']::text[]),
  mood text check (mood in ('romantic','emotional','funny','thriller','comfort')),
  updated_at timestamptz not null default now()
);
create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  drama_id uuid not null references public.dramas(id) on delete cascade,
  stars integer not null check (stars between 1 and 5),
  content text not null,
  spoiler boolean not null default false,
  author_name text not null default 'DoramaNest',
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id,drama_id),
  check ((is_deleted and content = '' and author_name = '') or
         (not is_deleted and length(trim(content)) between 10 and 1000))
);
create index if not exists watch_progress_recent_idx on public.watch_progress(user_id,updated_at desc);
create index if not exists reviews_drama_recent_idx on public.reviews(drama_id,created_at desc) where not is_deleted;
create index if not exists reviews_user_idx on public.reviews(user_id,updated_at desc);

create or replace function public.validate_watch_progress()
returns trigger language plpgsql set search_path = '' as $$
declare total integer;
begin
  select count(*) into total from public.episodes where drama_id = new.drama_id;
  if total = 0 or new.episodes_watched > total then
    raise exception 'Invalid episode count' using errcode = '23514';
  end if;
  if new.status = 'completed' and new.episodes_watched <> total then
    raise exception 'Completed progress must include every episode' using errcode = '23514';
  end if;
  new.updated_at = now();
  return new;
end;
$$;
drop trigger if exists validate_watch_progress on public.watch_progress;
create trigger validate_watch_progress before insert or update on public.watch_progress
for each row execute function public.validate_watch_progress();

create or replace function public.prepare_review()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'UPDATE' then
    new.id = old.id;
    new.user_id = old.user_id;
    new.drama_id = old.drama_id;
    new.created_at = old.created_at;
  else
    new.created_at = now();
  end if;
  new.updated_at = now();
  if new.is_deleted then
    new.content = ''; new.author_name = ''; new.spoiler = false;
  else
    new.content = trim(new.content);
    select nickname into new.author_name from public.profiles where id = new.user_id;
    new.author_name = coalesce(new.author_name,'DoramaNest');
  end if;
  return new;
end;
$$;
revoke all on function public.prepare_review() from public, anon, authenticated;
drop trigger if exists prepare_review on public.reviews;
create trigger prepare_review before insert or update on public.reviews
for each row execute function public.prepare_review();

alter table public.watch_progress enable row level security;
alter table public.user_preferences enable row level security;
alter table public.reviews enable row level security;
revoke all on public.watch_progress, public.user_preferences, public.reviews from anon, authenticated;
grant select,insert,update on public.watch_progress, public.user_preferences to authenticated;
grant select on public.reviews to anon,authenticated;
grant insert,update on public.reviews to authenticated;
grant update on public.favorites to authenticated;

do $$
declare t text;
begin
  foreach t in array array['watch_progress','user_preferences'] loop
    execute format('drop policy if exists owner_select on public.%I',t);
    execute format('drop policy if exists owner_insert on public.%I',t);
    execute format('drop policy if exists owner_update on public.%I',t);
    execute format('create policy owner_select on public.%I for select to authenticated using (user_id = (select auth.uid()))',t);
    execute format('create policy owner_insert on public.%I for insert to authenticated with check (user_id = (select auth.uid()))',t);
    execute format('create policy owner_update on public.%I for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()))',t);
  end loop;
  foreach t in array array['favorites','user_preferences'] loop
    execute format('drop trigger if exists account_set_updated_at on public.%I',t);
    execute format('create trigger account_set_updated_at before insert or update on public.%I for each row execute function public.set_updated_at()',t);
  end loop;
end;
$$;
drop policy if exists favorites_update_self on public.favorites;
create policy favorites_update_self on public.favorites for update to authenticated
using(user_id = (select auth.uid())) with check(user_id = (select auth.uid()));

drop policy if exists reviews_public_read on public.reviews;
create policy reviews_public_read on public.reviews for select to anon,authenticated using(true);
drop policy if exists reviews_owner_insert on public.reviews;
create policy reviews_owner_insert on public.reviews for insert to authenticated
with check(user_id = (select auth.uid()) and not coalesce((auth.jwt()->>'is_anonymous')::boolean,false));
drop policy if exists reviews_owner_update on public.reviews;
create policy reviews_owner_update on public.reviews for update to authenticated
using(user_id = (select auth.uid()) and not coalesce((auth.jwt()->>'is_anonymous')::boolean,false))
with check(user_id = (select auth.uid()) and not coalesce((auth.jwt()->>'is_anonymous')::boolean,false));
-- Public tombstones contain no review text. UPDATE events also notify filtered
-- subscriptions when a review is removed; DELETE filters cannot guarantee that.
create or replace view public.review_stats with(security_invoker = true) as
select drama_id, count(*)::integer as review_count, round(avg(stars),2) as average_stars
from public.reviews where not is_deleted group by drama_id;
grant select on public.review_stats to anon,authenticated;

-- Tables may already belong to the publication; keep this upgrade re-runnable.
do $$
declare t text;
begin
  if exists(select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array['favorites','watch_progress','user_preferences','reviews'] loop
      if not exists(select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
        execute format('alter publication supabase_realtime add table public.%I',t);
      end if;
    end loop;
  end if;
end;
$$;

-- Atomic catalog edit: all metadata, translations and episode-count changes
-- succeed together. SECURITY INVOKER retains RLS for every underlying write.
create or replace function public.save_drama(document jsonb)
returns setof public.dramas language plpgsql security invoker set search_path = '' as $$
declare
  target uuid;
  selected_genre uuid;
  translation record;
  episode_count integer;
  chosen_slug text;
begin
  if not public.is_catalog_admin() then raise exception 'Administrator access required' using errcode = '42501'; end if;
  target = coalesce(nullif(document->>'id','')::uuid, gen_random_uuid());
  episode_count = (document->>'episodes')::integer;
  if episode_count is null or episode_count not between 1 and 500 then
    raise exception 'Invalid episode count' using errcode = '23514';
  end if;
  -- Decreasing counts must not invalidate users' stored progress.
  if exists(select 1 from public.episodes where drama_id = target and number > episode_count) then
    raise exception 'Episode counts cannot be reduced after publication' using errcode = '23514';
  end if;
  insert into public.dramas(id,country,release_year,status,rating,poster_url,backdrop_url,original_title)
  values(target,document->>'country',(document->>'release_year')::integer,document->>'status',
    (document->>'rating')::numeric,document->>'poster_url',document->>'backdrop_url',document->>'original_title')
  on conflict(id) do update set country=excluded.country,release_year=excluded.release_year,
    status=excluded.status,rating=excluded.rating,poster_url=excluded.poster_url,
    backdrop_url=excluded.backdrop_url,original_title=excluded.original_title;
  for translation in select key,value from jsonb_each(document->'translations') loop
    if translation.key not in ('kk','ru','en','ko') then raise exception 'Unsupported locale'; end if;
    insert into public.drama_translations(drama_id,locale,title,description)
    values(target,translation.key,translation.value->>'title',coalesce(translation.value->>'description',''))
    on conflict(drama_id,locale) do update set title=excluded.title,description=excluded.description;
  end loop;
  if not exists(select 1 from public.drama_translations where drama_id = target) then raise exception 'A title is required'; end if;
  if jsonb_array_length(document->'genre_slugs') < 1 then raise exception 'A genre is required'; end if;
  delete from public.drama_genres where drama_id = target;
  for chosen_slug in select jsonb_array_elements_text(document->'genre_slugs') loop
    select id into selected_genre from public.genres where slug = chosen_slug;
    if selected_genre is null then raise exception 'Unknown genre'; end if;
    insert into public.drama_genres(drama_id,genre_id) values(target,selected_genre) on conflict do nothing;
  end loop;
  insert into public.episodes(drama_id,number) select target,generate_series(1,episode_count) on conflict(drama_id,number) do nothing;
  return query select * from public.dramas where id = target;
end;
$$;
revoke all on function public.save_drama(jsonb) from public,anon;
grant execute on function public.save_drama(jsonb) to authenticated;
notify pgrst, 'reload schema';
commit;
