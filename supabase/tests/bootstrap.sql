-- ONLY for a disposable vanilla PostgreSQL test database, never Supabase.
create role anon nologin;
create role authenticated nologin;
create schema auth;
create table auth.users (
  id uuid primary key, raw_user_meta_data jsonb not null default '{}',
  is_anonymous boolean not null default false, created_at timestamptz not null default now()
);
create function auth.uid() returns uuid language sql stable as $$
  select (nullif(current_setting('request.jwt.claims',true),'')::jsonb->>'sub')::uuid
$$;
create function auth.jwt() returns jsonb language sql stable as $$
  select coalesce(nullif(current_setting('request.jwt.claims',true),'')::jsonb,'{}'::jsonb)
$$;
grant usage on schema public,auth to anon,authenticated;
grant execute on function auth.uid(),auth.jwt() to anon,authenticated;
create publication supabase_realtime;
