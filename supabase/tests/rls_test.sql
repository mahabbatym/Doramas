-- Run after 01, 02, 03 and 04 in a disposable test database.
-- Every fixture is rolled back. Exceptions fail psql with ON_ERROR_STOP.
begin;
insert into auth.users(id,raw_user_meta_data) values
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','{"nickname":"Alice","is_admin":true}'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','{"nickname":"Bob"}'),
('cccccccc-cccc-cccc-cccc-cccccccccccc','{"nickname":"Catalog admin"}');
update public.profiles set is_admin=true where id='cccccccc-cccc-cccc-cccc-cccccccccccc';
select set_config('test.drama_id',(select id::text from public.dramas order by id limit 1),true);

do $$ begin
  assert (select count(*) = 3 from public.profiles), 'Auth profile trigger failed';
  assert not (select is_admin from public.profiles where id='aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), 'Metadata elevated admin';
  assert (select count(*)=4 from pg_publication_tables where pubname='supabase_realtime' and tablename in ('favorites','watch_progress','user_preferences','reviews')), 'Realtime publication incomplete';
end $$;

set local role authenticated;
select set_config('request.jwt.claims','{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated","is_anonymous":false}',true);
do $$ begin
  assert (select count(*) = 1 from public.profiles), 'Profile privacy failed';
  begin
    update public.profiles set is_admin=true where id=auth.uid();
    raise exception 'Profile escalation was permitted';
  exception when insufficient_privilege then null; end;
  insert into public.favorites(user_id,drama_id,is_saved) values(auth.uid(),current_setting('test.drama_id')::uuid,true)
  on conflict(user_id,drama_id) do update set is_saved=excluded.is_saved;
  insert into public.favorites(user_id,drama_id,is_saved) values(auth.uid(),current_setting('test.drama_id')::uuid,false)
  on conflict(user_id,drama_id) do update set is_saved=excluded.is_saved;
  assert (select count(*)=1 and bool_and(not is_saved) from public.favorites), 'Favorite upsert is not idempotent';
  begin
    insert into public.favorites(user_id,drama_id) values('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',current_setting('test.drama_id')::uuid);
    raise exception 'Cross-account favorite write was permitted';
  exception when insufficient_privilege then null; end;
  insert into public.watch_progress(user_id,drama_id,episodes_watched,status)
  values(auth.uid(),current_setting('test.drama_id')::uuid,2,'watching');
  begin
    update public.watch_progress set episodes_watched=99999;
    raise exception 'Invalid episode count was accepted';
  exception when check_violation then null; end;
  insert into public.user_preferences(user_id,genres,mood) values(auth.uid(),array['romance'],'romantic');
  begin
    insert into public.user_preferences(user_id) values('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb');
    raise exception 'Cross-account preference write was permitted';
  exception when insufficient_privilege then null; end;
  insert into public.reviews(user_id,drama_id,stars,content,author_name)
  values(auth.uid(),current_setting('test.drama_id')::uuid,5,'A thoughtful review of this drama.','Spoofed author');
  assert (select author_name='Alice' from public.reviews where user_id=auth.uid()), 'Review author spoofing was permitted';
  insert into public.reviews(user_id,drama_id,stars,content)
  values(auth.uid(),current_setting('test.drama_id')::uuid,4,'An edited thoughtful review of this drama.')
  on conflict(user_id,drama_id) do update set stars=excluded.stars,content=excluded.content;
  assert (select review_count=1 and average_stars=4 from public.review_stats where drama_id=current_setting('test.drama_id')::uuid), 'Review aggregation failed';
  begin
    perform public.save_drama('{"episodes":10}'::jsonb);
    raise exception 'Non-admin catalog RPC was permitted';
  exception when insufficient_privilege then null; end;
end $$;

select set_config('request.jwt.claims','{"sub":"bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb","role":"authenticated","is_anonymous":false}',true);
do $$ declare changed integer; begin
  assert (select count(*)=0 from public.favorites), 'Favorites leaked to another user';
  assert (select count(*)=0 from public.watch_progress), 'Progress leaked to another user';
  assert (select count(*)=0 from public.user_preferences), 'Preferences leaked to another user';
  update public.reviews set content='Unauthorized change' where user_id='aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
  get diagnostics changed = row_count;
  assert changed=0, 'Review edited by another user';
  update public.watch_progress set episodes_watched=0;
  get diagnostics changed = row_count;
  assert changed=0, 'Progress edited by another user';
end $$;

select set_config('request.jwt.claims','{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated","is_anonymous":false}',true);
update public.reviews set is_deleted=true where user_id=auth.uid();
set local role anon;
select set_config('request.jwt.claims','{"role":"anon"}',true);
do $$ begin
  assert (select count(*)>0 from public.dramas), 'Guest catalog unavailable';
  assert (select count(*)=0 from public.review_stats), 'Deleted review included in aggregate';
  assert (select bool_and(content='' and author_name='') from public.reviews), 'Deleted review content leaked';
  begin
    insert into public.reviews(user_id,drama_id,stars,content) values('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',current_setting('test.drama_id')::uuid,5,'Unauthorized guest review');
    raise exception 'Unauthenticated review write was permitted';
  exception when insufficient_privilege then null; end;
end $$;

set local role authenticated;
select set_config('request.jwt.claims','{"sub":"bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb","role":"authenticated","is_anonymous":true}',true);
do $$ begin
  begin
    insert into public.reviews(user_id,drama_id,stars,content) values(auth.uid(),current_setting('test.drama_id')::uuid,5,'Anonymous review attempt');
    raise exception 'Anonymous-session review was permitted';
  exception when insufficient_privilege then null; end;
end $$;

select set_config('request.jwt.claims','{"sub":"cccccccc-cccc-cccc-cccc-cccccccccccc","role":"authenticated","is_anonymous":false}',true);
do $$ declare saved public.dramas; before_count integer; begin
  select * into saved from public.save_drama('{
    "country":"KR","release_year":2024,"status":"released","rating":8,
    "original_title":"Test drama","episodes":3,"genre_slugs":["romance"],
    "translations":{"en":{"title":"Atomic test","description":"A test"},"ko":{"title":"검증","description":"테스트"}}
  }'::jsonb);
  assert saved.id is not null, 'Catalog RPC did not return ID';
  assert (select count(*)=3 from public.episodes where drama_id=saved.id), 'Episode transaction failed';
  assert (select count(*)=2 from public.drama_translations where drama_id=saved.id), 'Translations missing';
  select count(*) into before_count from public.dramas;
  begin
    perform public.save_drama('{"country":"KR","release_year":2024,"status":"released","rating":8,"episodes":3,"genre_slugs":["unknown-genre"],"translations":{"en":{"title":"Must rollback"}}}'::jsonb);
    raise exception 'Invalid genre accepted';
  exception when raise_exception then
    if sqlerrm <> 'Unknown genre' then raise; end if;
  end;
  assert (select count(*)=before_count from public.dramas), 'Failed RPC left a partial drama';
end $$;
rollback;
select 'PASS: profile creation, owner isolation, privilege escalation, idempotent favorites, progress validation, review ownership/aggregation/tombstones, anonymous rejection, atomic catalog RPC, Realtime publication' as result;
