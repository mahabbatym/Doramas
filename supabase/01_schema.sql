create extension if not exists pgcrypto;

create table if not exists public.dramas (
  id uuid primary key default gen_random_uuid(),
  country text not null check (country in ('KR', 'CN')),
  release_year integer not null check (release_year between 1900 and 2100),
  status text not null default 'released'
    check (status in ('announced', 'ongoing', 'completed', 'released', 'hiatus')),
  rating numeric(3, 1) not null default 0 check (rating between 0 and 10),
  poster_url text,
  backdrop_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.drama_translations (
  drama_id uuid not null references public.dramas(id) on delete cascade,
  locale text not null check (locale in ('kk', 'ru', 'en')),
  title text not null check (length(trim(title)) > 0),
  description text not null default '',
  primary key (drama_id, locale)
);

create table if not exists public.genres (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9-]+$')
);

create table if not exists public.genre_translations (
  genre_id uuid not null references public.genres(id) on delete cascade,
  locale text not null check (locale in ('kk', 'ru', 'en')),
  name text not null check (length(trim(name)) > 0),
  primary key (genre_id, locale)
);

create table if not exists public.drama_genres (
  drama_id uuid not null references public.dramas(id) on delete cascade,
  genre_id uuid not null references public.genres(id) on delete cascade,
  primary key (drama_id, genre_id)
);

create table if not exists public.actors (
  id uuid primary key default gen_random_uuid(),
  photo_url text
);

create table if not exists public.actor_translations (
  actor_id uuid not null references public.actors(id) on delete cascade,
  locale text not null check (locale in ('kk', 'ru', 'en')),
  name text not null check (length(trim(name)) > 0),
  bio text not null default '',
  primary key (actor_id, locale)
);

create table if not exists public.drama_cast (
  drama_id uuid not null references public.dramas(id) on delete cascade,
  actor_id uuid not null references public.actors(id) on delete cascade,
  role_order integer not null default 0 check (role_order >= 0),
  primary key (drama_id, actor_id),
  unique (drama_id, role_order)
);

create table if not exists public.episodes (
  id uuid primary key default gen_random_uuid(),
  drama_id uuid not null references public.dramas(id) on delete cascade,
  number integer not null check (number > 0),
  youtube_video_id text check (youtube_video_id is null or length(youtube_video_id) = 11),
  thumbnail_url text,
  duration_seconds integer check (duration_seconds is null or duration_seconds > 0),
  unique (drama_id, number)
);

create table if not exists public.episode_translations (
  episode_id uuid not null references public.episodes(id) on delete cascade,
  locale text not null check (locale in ('kk', 'ru', 'en')),
  title text not null check (length(trim(title)) > 0),
  primary key (episode_id, locale)
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  is_admin boolean not null default false
);

create table if not exists public.favorites (
  user_id uuid not null references auth.users(id) on delete cascade,
  drama_id uuid not null references public.dramas(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, drama_id)
);

create index if not exists drama_translations_title_idx
  on public.drama_translations (locale, title);
create index if not exists dramas_catalog_idx
  on public.dramas (country, release_year desc, rating desc);
create index if not exists drama_genres_genre_idx
  on public.drama_genres (genre_id, drama_id);
create index if not exists drama_cast_actor_idx
  on public.drama_cast (actor_id, drama_id);
create index if not exists episodes_drama_idx
  on public.episodes (drama_id, number);
create index if not exists favorites_user_idx
  on public.favorites (user_id, created_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists dramas_set_updated_at on public.dramas;
create trigger dramas_set_updated_at
before update on public.dramas
for each row execute function public.set_updated_at();

-- New anonymous users get a non-admin profile row; elevation is manual.
create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.profiles (id, is_admin)
  values (new.id, false)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_dorama_nest on auth.users;
create trigger on_auth_user_created_dorama_nest
after insert on auth.users
for each row execute function public.create_profile_for_new_user();

insert into public.profiles (id, is_admin)
select id, false from auth.users
on conflict (id) do nothing;
