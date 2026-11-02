insert into public.dramas
  (id, country, release_year, status, rating, poster_url, backdrop_url)
values
  (md5('dorama:hidden-love')::uuid, 'CN', 2023, 'completed', 9.4, null, null),
  (md5('dorama:dream-high')::uuid, 'KR', 2011, 'completed', 9.1, null, null),
  (md5('dorama:queen-of-tears')::uuid, 'KR', 2024, 'completed', 9.3, null, null),
  (md5('dorama:when-i-fly')::uuid, 'CN', 2023, 'completed', 9.2, null, null),
  (md5('dorama:goblin')::uuid, 'KR', 2016, 'completed', 9.5, null, null),
  (md5('dorama:love-o2o')::uuid, 'CN', 2016, 'completed', 8.9, null, null),
  (md5('dorama:business-proposal')::uuid, 'KR', 2022, 'completed', 9.0, null, null),
  (md5('dorama:crash-landing')::uuid, 'KR', 2019, 'completed', 9.6, null, null),
  (md5('dorama:lovely-runner')::uuid, 'KR', 2024, 'completed', 9.7, null, null),
  (md5('dorama:descendants-sun')::uuid, 'KR', 2016, 'completed', 9.0, null, null),
  (md5('dorama:go-ahead')::uuid, 'CN', 2020, 'completed', 9.3, null, null),
  (md5('dorama:the-untamed')::uuid, 'CN', 2019, 'completed', 9.5, null, null)
on conflict (id) do nothing;

insert into public.drama_translations (drama_id, locale, title, description)
values
  (md5('dorama:hidden-love')::uuid, 'kk', 'Жасырын махаббат', 'Сан Чжидің ағасының досына деген үнсіз сезімі жылдар өте келе өзара құрмет пен нәзік махаббатқа ұласады.'),
  (md5('dorama:hidden-love')::uuid, 'ru', 'Скрытая любовь', 'Тихая влюблённость Сан Чжи в друга брата взрослеет вместе с ней и со временем становится взаимным чувством.'),
  (md5('dorama:hidden-love')::uuid, 'en', 'Hidden Love', 'Sang Zhi quietly falls for her brother’s friend; years later, growing up gives their gentle connection room to become mutual.'),
  (md5('dorama:dream-high')::uuid, 'kk', 'Арманға ұмтыл', 'Өнер мектебінің алты оқушысы музыка, достық және табандылық арқылы сахнаға шығуды армандайды.'),
  (md5('dorama:dream-high')::uuid, 'ru', 'Одержимые мечтой', 'Шесть учеников школы искусств идут к сцене через музыку, дружбу, соперничество и упорную работу.'),
  (md5('dorama:dream-high')::uuid, 'en', 'Dream High', 'Six students at an arts school pursue the stage through music, friendship, rivalry and hard work.'),
  (md5('dorama:queen-of-tears')::uuid, 'kk', 'Көз жасының патшайымы', 'Қиын кезеңді бастан өткерген ерлі-зайыптылар бір-бірін қайта танып, бірге құрған өмірін сақтап қалуға тырысады.'),
  (md5('dorama:queen-of-tears')::uuid, 'ru', 'Королева слёз', 'Супруги, переживающие кризис, заново учатся слышать друг друга и защищать совместную жизнь.'),
  (md5('dorama:queen-of-tears')::uuid, 'en', 'Queen of Tears', 'A married couple facing a crisis learn to listen to each other again and fight for the life they built.'),
  (md5('dorama:when-i-fly')::uuid, 'kk', 'Саған қарай ұшамын', 'Жарқын мінезді қыз бен тұйық сыныптасының мектеп жылдарынан басталған достығы есейген сайын тереңдей түседі.'),
  (md5('dorama:when-i-fly')::uuid, 'ru', 'Когда я лечу к тебе', 'Дружба энергичной школьницы и её сдержанного одноклассника постепенно превращается в нежную историю взросления.'),
  (md5('dorama:when-i-fly')::uuid, 'en', 'When I Fly Towards You', 'An outgoing student and her reserved classmate grow from school friends into a tender story about growing up.'),
  (md5('dorama:goblin')::uuid, 'kk', 'Гоблин', 'Өлмейтін жауынгердің қарғысын тек қалыңдығы бұза алады; олардың жолында өлім періштесі мен батыл қыз кездеседі.'),
  (md5('dorama:goblin')::uuid, 'ru', 'Токкэби', 'Проклятие бессмертного воина может снять только его невеста; на их пути появляются жнец душ и смелая девушка.'),
  (md5('dorama:goblin')::uuid, 'en', 'Guardian: The Lonely and Great God', 'Only the immortal warrior’s bride can end his curse, drawing a grim reaper and a spirited young woman into their lives.'),
  (md5('dorama:love-o2o')::uuid, 'kk', 'Махаббат онлайн', 'Онлайн ойында танысқан екі студент виртуалды әлемдегі серіктестіктің шынайы өмірде де жалғасатынын байқайды.'),
  (md5('dorama:love-o2o')::uuid, 'ru', 'Любовь онлайн', 'Двое студентов знакомятся в сетевой игре и обнаруживают, что виртуальное партнёрство продолжается в реальной жизни.'),
  (md5('dorama:love-o2o')::uuid, 'en', 'Love O2O', 'Two university students meet through an online game and discover their virtual partnership carries into everyday life.'),
  (md5('dorama:business-proposal')::uuid, 'kk', 'Іскерлік ұсыныс', 'Досының орнына кездесуге барған қызметкер өз компаниясының басшысымен танысып, ойдан шығарылған романтикаға кіріседі.'),
  (md5('dorama:business-proposal')::uuid, 'ru', 'Деловое предложение', 'Сотрудница идёт на свидание вместо подруги и неожиданно встречает директора собственной компании.'),
  (md5('dorama:business-proposal')::uuid, 'en', 'Business Proposal', 'An employee takes her friend’s place on a blind date and finds herself facing the CEO of her own company.'),
  (md5('dorama:crash-landing')::uuid, 'kk', 'Күтпеген қону', 'Параплан апаты оңтүстіккореялық кәсіпкерді Солтүстік Кореяға алып келеді; сол жерде офицер оған жасырынуға көмектеседі.'),
  (md5('dorama:crash-landing')::uuid, 'ru', 'Аварийная посадка любви', 'После аварии на параплане южнокорейская предпринимательница оказывается на Севере, где офицер помогает ей скрыться.'),
  (md5('dorama:crash-landing')::uuid, 'en', 'Crash Landing on You', 'A paragliding accident leaves a South Korean entrepreneur across the border, where an officer helps keep her hidden.'),
  (md5('dorama:lovely-runner')::uuid, 'kk', 'Сүйкімді жүгіруші', 'Сүйікті әншісінің өмірін сақтап қалғысы келген жанкүйер өткен шаққа оралып, екеуіне де жаңа мүмкіндік іздейді.'),
  (md5('dorama:lovely-runner')::uuid, 'ru', 'Хватай Сон-дже и беги', 'Поклонница возвращается в прошлое, чтобы спасти любимого певца и дать им обоим шанс изменить будущее.'),
  (md5('dorama:lovely-runner')::uuid, 'en', 'Lovely Runner', 'A devoted fan travels back in time to save her favorite singer and give them both a chance to change the future.'),
  (md5('dorama:descendants-sun')::uuid, 'kk', 'Күн ұрпақтары', 'Бітімгерлік миссиядағы сарбаз бен дәрігер соғыс, табиғи апат және қызметтік парыз арасында қарым-қатынасын сақтауға тырысады.'),
  (md5('dorama:descendants-sun')::uuid, 'ru', 'Потомки солнца', 'Военный и врач встречаются на миротворческой миссии, где их отношения проходят испытание конфликтами и долгом.'),
  (md5('dorama:descendants-sun')::uuid, 'en', 'Descendants of the Sun', 'A soldier and a doctor meet on a peacekeeping mission, where conflict and duty test their growing relationship.'),
  (md5('dorama:go-ahead')::uuid, 'kk', 'Алға бірге', 'Бір шаңырақта өскен үш жасөспірім туған отбасыларының қиындықтарына қарамастан, бауырдай жақын болып қалады.'),
  (md5('dorama:go-ahead')::uuid, 'ru', 'Вперёд', 'Трое подростков, выросших в одной семье, остаются близкими, даже когда им приходится справляться с непростым прошлым.'),
  (md5('dorama:go-ahead')::uuid, 'en', 'Go Ahead', 'Three teenagers raised in one household remain close as siblings while each learns to face a complicated past.'),
  (md5('dorama:the-untamed')::uuid, 'kk', 'Тізгінсіз', 'Екі жас рух өсіруші ежелгі құпияны зерттеп, әулеттер арасындағы қақтығыстың астарында жатқан шындықты ашады.'),
  (md5('dorama:the-untamed')::uuid, 'ru', 'Неукротимый', 'Два молодых заклинателя расследуют древнюю тайну и раскрывают правду, скрытую за враждой кланов.'),
  (md5('dorama:the-untamed')::uuid, 'en', 'The Untamed', 'Two young cultivators investigate an old mystery and uncover the truth beneath a feud between powerful clans.')
on conflict (drama_id, locale) do nothing;

insert into public.genres (id, slug) values
  (md5('genre:romance')::uuid, 'romance'),
  (md5('genre:comedy')::uuid, 'comedy'),
  (md5('genre:fantasy')::uuid, 'fantasy'),
  (md5('genre:music')::uuid, 'music'),
  (md5('genre:drama')::uuid, 'drama'),
  (md5('genre:mystery')::uuid, 'mystery'),
  (md5('genre:family')::uuid, 'family'),
  (md5('genre:action')::uuid, 'action')
on conflict (id) do nothing;

insert into public.genre_translations (genre_id, locale, name) values
  (md5('genre:romance')::uuid, 'kk', 'Романтика'), (md5('genre:romance')::uuid, 'ru', 'Романтика'), (md5('genre:romance')::uuid, 'en', 'Romance'),
  (md5('genre:comedy')::uuid, 'kk', 'Комедия'), (md5('genre:comedy')::uuid, 'ru', 'Комедия'), (md5('genre:comedy')::uuid, 'en', 'Comedy'),
  (md5('genre:fantasy')::uuid, 'kk', 'Фэнтези'), (md5('genre:fantasy')::uuid, 'ru', 'Фэнтези'), (md5('genre:fantasy')::uuid, 'en', 'Fantasy'),
  (md5('genre:music')::uuid, 'kk', 'Музыка'), (md5('genre:music')::uuid, 'ru', 'Музыка'), (md5('genre:music')::uuid, 'en', 'Music'),
  (md5('genre:drama')::uuid, 'kk', 'Драма'), (md5('genre:drama')::uuid, 'ru', 'Драма'), (md5('genre:drama')::uuid, 'en', 'Drama'),
  (md5('genre:mystery')::uuid, 'kk', 'Детектив'), (md5('genre:mystery')::uuid, 'ru', 'Детектив'), (md5('genre:mystery')::uuid, 'en', 'Mystery'),
  (md5('genre:family')::uuid, 'kk', 'Отбасы'), (md5('genre:family')::uuid, 'ru', 'Семейная история'), (md5('genre:family')::uuid, 'en', 'Family'),
  (md5('genre:action')::uuid, 'kk', 'Шытырман оқиға'), (md5('genre:action')::uuid, 'ru', 'Приключения'), (md5('genre:action')::uuid, 'en', 'Adventure')
on conflict (genre_id, locale) do nothing;

with links(drama_slug, genre_slug) as (values
  ('hidden-love', 'romance'), ('hidden-love', 'drama'), ('hidden-love', 'family'),
  ('dream-high', 'music'), ('dream-high', 'romance'), ('dream-high', 'drama'),
  ('queen-of-tears', 'romance'), ('queen-of-tears', 'drama'), ('queen-of-tears', 'comedy'),
  ('when-i-fly', 'romance'), ('when-i-fly', 'comedy'), ('when-i-fly', 'drama'),
  ('goblin', 'fantasy'), ('goblin', 'romance'), ('goblin', 'drama'),
  ('love-o2o', 'romance'), ('love-o2o', 'comedy'), ('love-o2o', 'drama'),
  ('business-proposal', 'romance'), ('business-proposal', 'comedy'), ('business-proposal', 'drama'),
  ('crash-landing', 'romance'), ('crash-landing', 'drama'), ('crash-landing', 'action'),
  ('lovely-runner', 'romance'), ('lovely-runner', 'fantasy'), ('lovely-runner', 'drama'),
  ('descendants-sun', 'romance'), ('descendants-sun', 'action'), ('descendants-sun', 'drama'),
  ('go-ahead', 'family'), ('go-ahead', 'drama'), ('go-ahead', 'romance'),
  ('the-untamed', 'fantasy'), ('the-untamed', 'action'), ('the-untamed', 'drama')
)
insert into public.drama_genres (drama_id, genre_id)
select md5('dorama:' || links.drama_slug)::uuid,
       md5('genre:' || links.genre_slug)::uuid
from links
on conflict do nothing;

with cast_seed(drama_slug, actor_name) as (values
  ('hidden-love', 'Zhao Lusi'), ('hidden-love', 'Chen Zheyuan'), ('hidden-love', 'Victor Ma'), ('hidden-love', 'Zeng Li'),
  ('dream-high', 'Kim Soo-hyun'), ('dream-high', 'Bae Suzy'), ('dream-high', 'Ok Taec-yeon'), ('dream-high', 'IU'),
  ('queen-of-tears', 'Kim Soo-hyun'), ('queen-of-tears', 'Kim Ji-won'), ('queen-of-tears', 'Park Sung-hoon'), ('queen-of-tears', 'Kwak Dong-yeon'),
  ('when-i-fly', 'Zhou Yiran'), ('when-i-fly', 'Zhang Miaoyi'), ('when-i-fly', 'Jiang Zhinan'), ('when-i-fly', 'Guo Zhe'),
  ('goblin', 'Gong Yoo'), ('goblin', 'Kim Go-eun'), ('goblin', 'Lee Dong-wook'), ('goblin', 'Yoo In-na'),
  ('love-o2o', 'Yang Yang'), ('love-o2o', 'Zheng Shuang'), ('love-o2o', 'Mao Xiaotong'), ('love-o2o', 'Bai Yu'),
  ('business-proposal', 'Ahn Hyo-seop'), ('business-proposal', 'Kim Se-jeong'), ('business-proposal', 'Kim Min-kyu'), ('business-proposal', 'Seol In-ah'),
  ('crash-landing', 'Hyun Bin'), ('crash-landing', 'Son Ye-jin'), ('crash-landing', 'Seo Ji-hye'), ('crash-landing', 'Kim Jung-hyun'),
  ('lovely-runner', 'Byeon Woo-seok'), ('lovely-runner', 'Kim Hye-yoon'), ('lovely-runner', 'Song Geon-hee'), ('lovely-runner', 'Lee Seung-hyub'),
  ('descendants-sun', 'Song Joong-ki'), ('descendants-sun', 'Song Hye-kyo'), ('descendants-sun', 'Jin Goo'), ('descendants-sun', 'Kim Ji-won'),
  ('go-ahead', 'Tan Songyun'), ('go-ahead', 'Song Weilong'), ('go-ahead', 'Zhang Xincheng'), ('go-ahead', 'Tu Songyan'),
  ('the-untamed', 'Xiao Zhan'), ('the-untamed', 'Wang Yibo'), ('the-untamed', 'Meng Ziyi'), ('the-untamed', 'Xuan Lu')
)
insert into public.actors (id, photo_url)
select distinct md5('actor:' || actor_name)::uuid, null
from cast_seed
on conflict (id) do nothing;

with cast_seed(drama_slug, actor_name) as (values
  ('hidden-love', 'Zhao Lusi'), ('hidden-love', 'Chen Zheyuan'), ('hidden-love', 'Victor Ma'), ('hidden-love', 'Zeng Li'),
  ('dream-high', 'Kim Soo-hyun'), ('dream-high', 'Bae Suzy'), ('dream-high', 'Ok Taec-yeon'), ('dream-high', 'IU'),
  ('queen-of-tears', 'Kim Soo-hyun'), ('queen-of-tears', 'Kim Ji-won'), ('queen-of-tears', 'Park Sung-hoon'), ('queen-of-tears', 'Kwak Dong-yeon'),
  ('when-i-fly', 'Zhou Yiran'), ('when-i-fly', 'Zhang Miaoyi'), ('when-i-fly', 'Jiang Zhinan'), ('when-i-fly', 'Guo Zhe'),
  ('goblin', 'Gong Yoo'), ('goblin', 'Kim Go-eun'), ('goblin', 'Lee Dong-wook'), ('goblin', 'Yoo In-na'),
  ('love-o2o', 'Yang Yang'), ('love-o2o', 'Zheng Shuang'), ('love-o2o', 'Mao Xiaotong'), ('love-o2o', 'Bai Yu'),
  ('business-proposal', 'Ahn Hyo-seop'), ('business-proposal', 'Kim Se-jeong'), ('business-proposal', 'Kim Min-kyu'), ('business-proposal', 'Seol In-ah'),
  ('crash-landing', 'Hyun Bin'), ('crash-landing', 'Son Ye-jin'), ('crash-landing', 'Seo Ji-hye'), ('crash-landing', 'Kim Jung-hyun'),
  ('lovely-runner', 'Byeon Woo-seok'), ('lovely-runner', 'Kim Hye-yoon'), ('lovely-runner', 'Song Geon-hee'), ('lovely-runner', 'Lee Seung-hyub'),
  ('descendants-sun', 'Song Joong-ki'), ('descendants-sun', 'Song Hye-kyo'), ('descendants-sun', 'Jin Goo'), ('descendants-sun', 'Kim Ji-won'),
  ('go-ahead', 'Tan Songyun'), ('go-ahead', 'Song Weilong'), ('go-ahead', 'Zhang Xincheng'), ('go-ahead', 'Tu Songyan'),
  ('the-untamed', 'Xiao Zhan'), ('the-untamed', 'Wang Yibo'), ('the-untamed', 'Meng Ziyi'), ('the-untamed', 'Xuan Lu')
), actor_rows as (
  select distinct md5('actor:' || c.actor_name)::uuid as actor_id,
         d.country,
         dt.locale,
         c.actor_name
  from cast_seed c
  join public.dramas d on d.id = md5('dorama:' || c.drama_slug)::uuid
  join public.drama_translations dt on dt.drama_id = d.id
)
insert into public.actor_translations (actor_id, locale, name, bio)
select actor_id, locale,
       actor_name,
       case locale
         when 'kk' then case country when 'KR' then 'Оңтүстік Кореяның кино және теледидар актері.' else 'Қытайдың кино және теледидар актері.' end
         when 'ru' then case country when 'KR' then 'Южнокорейский актёр кино и телевидения.' else 'Китайский актёр кино и телевидения.' end
         else case country when 'KR' then 'South Korean film and television actor.' else 'Chinese film and television actor.' end
       end
from actor_rows
on conflict (actor_id, locale) do nothing;

with cast_seed(drama_slug, actor_name) as (values
  ('hidden-love', 'Zhao Lusi'), ('hidden-love', 'Chen Zheyuan'), ('hidden-love', 'Victor Ma'), ('hidden-love', 'Zeng Li'),
  ('dream-high', 'Kim Soo-hyun'), ('dream-high', 'Bae Suzy'), ('dream-high', 'Ok Taec-yeon'), ('dream-high', 'IU'),
  ('queen-of-tears', 'Kim Soo-hyun'), ('queen-of-tears', 'Kim Ji-won'), ('queen-of-tears', 'Park Sung-hoon'), ('queen-of-tears', 'Kwak Dong-yeon'),
  ('when-i-fly', 'Zhou Yiran'), ('when-i-fly', 'Zhang Miaoyi'), ('when-i-fly', 'Jiang Zhinan'), ('when-i-fly', 'Guo Zhe'),
  ('goblin', 'Gong Yoo'), ('goblin', 'Kim Go-eun'), ('goblin', 'Lee Dong-wook'), ('goblin', 'Yoo In-na'),
  ('love-o2o', 'Yang Yang'), ('love-o2o', 'Zheng Shuang'), ('love-o2o', 'Mao Xiaotong'), ('love-o2o', 'Bai Yu'),
  ('business-proposal', 'Ahn Hyo-seop'), ('business-proposal', 'Kim Se-jeong'), ('business-proposal', 'Kim Min-kyu'), ('business-proposal', 'Seol In-ah'),
  ('crash-landing', 'Hyun Bin'), ('crash-landing', 'Son Ye-jin'), ('crash-landing', 'Seo Ji-hye'), ('crash-landing', 'Kim Jung-hyun'),
  ('lovely-runner', 'Byeon Woo-seok'), ('lovely-runner', 'Kim Hye-yoon'), ('lovely-runner', 'Song Geon-hee'), ('lovely-runner', 'Lee Seung-hyub'),
  ('descendants-sun', 'Song Joong-ki'), ('descendants-sun', 'Song Hye-kyo'), ('descendants-sun', 'Jin Goo'), ('descendants-sun', 'Kim Ji-won'),
  ('go-ahead', 'Tan Songyun'), ('go-ahead', 'Song Weilong'), ('go-ahead', 'Zhang Xincheng'), ('go-ahead', 'Tu Songyan'),
  ('the-untamed', 'Xiao Zhan'), ('the-untamed', 'Wang Yibo'), ('the-untamed', 'Meng Ziyi'), ('the-untamed', 'Xuan Lu')
), ordered_cast as (
  select md5('dorama:' || drama_slug)::uuid as drama_id,
         md5('actor:' || actor_name)::uuid as actor_id,
         row_number() over (partition by drama_slug order by actor_name)::integer - 1 as role_order
  from cast_seed
)
insert into public.drama_cast (drama_id, actor_id, role_order)
select drama_id, actor_id, role_order from ordered_cast
on conflict (drama_id, actor_id) do nothing;

with seed_episodes(drama_slug, episode_count) as (values
  ('hidden-love', 25), ('dream-high', 16), ('queen-of-tears', 16), ('when-i-fly', 24),
  ('goblin', 16), ('love-o2o', 30), ('business-proposal', 12), ('crash-landing', 16),
  ('lovely-runner', 16), ('descendants-sun', 16), ('go-ahead', 46), ('the-untamed', 50)
)
insert into public.episodes (id, drama_id, number, youtube_video_id, thumbnail_url)
select md5('episode:' || s.drama_slug || ':' || n)::uuid,
       md5('dorama:' || s.drama_slug)::uuid,
       n, null, null
from seed_episodes s
cross join lateral generate_series(1, s.episode_count) n
on conflict (drama_id, number) do nothing;

with seed_episodes(drama_slug, episode_count) as (values
  ('hidden-love', 25), ('dream-high', 16), ('queen-of-tears', 16), ('when-i-fly', 24),
  ('goblin', 16), ('love-o2o', 30), ('business-proposal', 12), ('crash-landing', 16),
  ('lovely-runner', 16), ('descendants-sun', 16), ('go-ahead', 46), ('the-untamed', 50)
), locales(locale) as (values ('kk'), ('ru'), ('en'))
insert into public.episode_translations (episode_id, locale, title)
select md5('episode:' || s.drama_slug || ':' || n)::uuid,
       locales.locale,
       case locales.locale
         when 'kk' then n::text || '-серия'
         when 'ru' then 'Серия ' || n::text
         else 'Episode ' || n::text
       end
from seed_episodes s
cross join lateral generate_series(1, s.episode_count) n
cross join locales
on conflict (episode_id, locale) do nothing;

-- Thirty additional Korean dramas with localized copy and official YouTube trailer thumbnails.
-- Thumbnail URLs are used as artwork only; no trailer is marked as a full episode video.
insert into public.dramas (id, country, release_year, status, rating, poster_url, backdrop_url) values
  ('00563caa-0eab-dd38-098c-76d1b8ba8511'::uuid, 'KR', 2023, 'completed', 9.0, 'https://img.youtube.com/vi/D-bAfFqvxZg/hqdefault.jpg', 'https://img.youtube.com/vi/D-bAfFqvxZg/hqdefault.jpg'),
  ('597d162b-19c4-5910-14d8-f93eb4b65b85'::uuid, 'KR', 2021, 'completed', 8.7, 'https://img.youtube.com/vi/ZOl7iOrD31Q/hqdefault.jpg', 'https://img.youtube.com/vi/ZOl7iOrD31Q/hqdefault.jpg'),
  ('1d358aa4-82d7-e125-bc88-62275ade2ff3'::uuid, 'KR', 2020, 'completed', 8.5, 'https://img.youtube.com/vi/7rI56NmD33Y/hqdefault.jpg', 'https://img.youtube.com/vi/7rI56NmD33Y/hqdefault.jpg'),
  ('aaa8f3c5-26a4-80b1-0f02-8b7d0d654bc4'::uuid, 'KR', 2022, 'completed', 9.1, 'https://img.youtube.com/vi/tqVVrTvrI8U/hqdefault.jpg', 'https://img.youtube.com/vi/tqVVrTvrI8U/hqdefault.jpg'),
  ('cb9b6d55-664a-4d73-656f-26dbb8be6b1c'::uuid, 'KR', 2018, 'completed', 8.8, 'https://img.youtube.com/vi/EDGfWN36q5o/hqdefault.jpg', 'https://img.youtube.com/vi/EDGfWN36q5o/hqdefault.jpg'),
  ('b078ae85-6e4f-2920-e536-394eacb54b71'::uuid, 'KR', 2022, 'completed', 9.1, 'https://img.youtube.com/vi/gYp4cKumTwU/hqdefault.jpg', 'https://img.youtube.com/vi/gYp4cKumTwU/hqdefault.jpg'),
  ('ef310ad3-b1ed-c880-e0bc-4f3763f61945'::uuid, 'KR', 2021, 'completed', 9.0, 'https://img.youtube.com/vi/z66fazyp3-M/hqdefault.jpg', 'https://img.youtube.com/vi/z66fazyp3-M/hqdefault.jpg'),
  ('e8ac7333-f413-ee4a-5400-57ccfb6bbeff'::uuid, 'KR', 2020, 'completed', 8.6, 'https://img.youtube.com/vi/BemKyzbLDDc/hqdefault.jpg', 'https://img.youtube.com/vi/BemKyzbLDDc/hqdefault.jpg'),
  ('40a1b2d0-0d23-130a-52dc-a2221523dc00'::uuid, 'KR', 2022, 'completed', 9.2, 'https://img.youtube.com/vi/HmQcFU2NLKc/hqdefault.jpg', 'https://img.youtube.com/vi/HmQcFU2NLKc/hqdefault.jpg'),
  ('bd3d3d3a-df98-df03-5372-8fcb74e6e6f0'::uuid, 'KR', 2023, 'completed', 8.2, 'https://img.youtube.com/vi/c_sKheuGE7o/hqdefault.jpg', 'https://img.youtube.com/vi/c_sKheuGE7o/hqdefault.jpg'),
  ('3bb5ca78-1d3c-20fe-7263-85b7fc4044fb'::uuid, 'KR', 2021, 'completed', 8.9, 'https://img.youtube.com/vi/p_dDoDQ8u94/hqdefault.jpg', 'https://img.youtube.com/vi/p_dDoDQ8u94/hqdefault.jpg'),
  ('4af79641-1f66-b691-6bcd-9e7c2719ec16'::uuid, 'KR', 2020, 'completed', 9.2, 'https://img.youtube.com/vi/ulf9PtJjVjc/hqdefault.jpg', 'https://img.youtube.com/vi/ulf9PtJjVjc/hqdefault.jpg'),
  ('0626c54d-c154-5885-7051-5dd91cf3c2f2'::uuid, 'KR', 2023, 'completed', 8.8, 'https://img.youtube.com/vi/CzVi_hIZ3mc/hqdefault.jpg', 'https://img.youtube.com/vi/CzVi_hIZ3mc/hqdefault.jpg'),
  ('619ded35-8caa-ecdf-adca-2d9cb8a9f731'::uuid, 'KR', 2022, 'completed', 8.4, 'https://img.youtube.com/vi/IN5TD4VRcSM/hqdefault.jpg', 'https://img.youtube.com/vi/IN5TD4VRcSM/hqdefault.jpg'),
  ('23197a5b-81c5-b746-2ef5-81bab95cc4aa'::uuid, 'KR', 2021, 'completed', 8.0, 'https://img.youtube.com/vi/Af_Hj0MDBBQ/hqdefault.jpg', 'https://img.youtube.com/vi/Af_Hj0MDBBQ/hqdefault.jpg'),
  ('841ad032-e68e-0c52-4591-8cffb2ded48a'::uuid, 'KR', 2022, 'completed', 8.4, 'https://img.youtube.com/vi/pJpPCkFHitM/hqdefault.jpg', 'https://img.youtube.com/vi/pJpPCkFHitM/hqdefault.jpg'),
  ('c5afc68c-554d-408f-fe55-9439439d4bdd'::uuid, 'KR', 2023, 'completed', 8.1, 'https://img.youtube.com/vi/vUTY9tZk5TY/hqdefault.jpg', 'https://img.youtube.com/vi/vUTY9tZk5TY/hqdefault.jpg'),
  ('dd53b4ef-f377-ffd8-cec3-04fad2ffd6e5'::uuid, 'KR', 2023, 'completed', 8.0, 'https://img.youtube.com/vi/xwVBHHsSKsI/hqdefault.jpg', 'https://img.youtube.com/vi/xwVBHHsSKsI/hqdefault.jpg'),
  ('6c5c2124-7beb-26a3-0e7a-7a98725ed130'::uuid, 'KR', 2020, 'completed', 8.7, 'https://img.youtube.com/vi/rI55SRM6uhs/hqdefault.jpg', 'https://img.youtube.com/vi/rI55SRM6uhs/hqdefault.jpg'),
  ('013b3fd2-dcb4-4cd6-0bb8-9376499ba85c'::uuid, 'KR', 2021, 'completed', 9.0, 'https://img.youtube.com/vi/S12-4mXCNj4/hqdefault.jpg', 'https://img.youtube.com/vi/S12-4mXCNj4/hqdefault.jpg'),
  ('d2cf0811-1d32-6536-eaeb-60c3e2241702'::uuid, 'KR', 2021, 'completed', 8.8, 'https://img.youtube.com/vi/oqxAJKy0ii4/hqdefault.jpg', 'https://img.youtube.com/vi/oqxAJKy0ii4/hqdefault.jpg'),
  ('76bb6cc9-c68d-38f3-6519-a48f14792f4c'::uuid, 'KR', 2023, 'completed', 8.2, 'https://img.youtube.com/vi/nLcpyyM0drA/hqdefault.jpg', 'https://img.youtube.com/vi/nLcpyyM0drA/hqdefault.jpg'),
  ('d01520a6-237a-76c5-8fd3-d1513fbbc32c'::uuid, 'KR', 2021, 'completed', 8.0, 'https://img.youtube.com/vi/xJCTxUuu3js/hqdefault.jpg', 'https://img.youtube.com/vi/xJCTxUuu3js/hqdefault.jpg'),
  ('52527621-94e9-7ad9-c71d-22b4c2b105a3'::uuid, 'KR', 2020, 'completed', 9.0, 'https://img.youtube.com/vi/50ek4HQo0Bc/hqdefault.jpg', 'https://img.youtube.com/vi/50ek4HQo0Bc/hqdefault.jpg'),
  ('c7fba6e6-4e26-5c2c-8fbe-d9f538b9ec51'::uuid, 'KR', 2020, 'completed', 8.8, 'https://img.youtube.com/vi/NeaHNQJ1kCo/hqdefault.jpg', 'https://img.youtube.com/vi/NeaHNQJ1kCo/hqdefault.jpg'),
  ('0459e8bd-83bf-6065-df94-1a03c222aff6'::uuid, 'KR', 2024, 'completed', 8.0, 'https://img.youtube.com/vi/zvowLTLYJN0/hqdefault.jpg', 'https://img.youtube.com/vi/zvowLTLYJN0/hqdefault.jpg'),
  ('e20fe09c-1cd9-3b93-3bf9-913fd75c7a20'::uuid, 'KR', 2023, 'completed', 8.1, 'https://img.youtube.com/vi/4c1kvLYu6ls/hqdefault.jpg', 'https://img.youtube.com/vi/4c1kvLYu6ls/hqdefault.jpg'),
  ('96a2ec0f-7706-6d6c-991a-1b8c7cb8c382'::uuid, 'KR', 2022, 'completed', 8.3, 'https://img.youtube.com/vi/TXCqYohW0bA/hqdefault.jpg', 'https://img.youtube.com/vi/TXCqYohW0bA/hqdefault.jpg'),
  ('9b81e6f3-b58e-337a-cdcb-7e8b502b0b6b'::uuid, 'KR', 2021, 'completed', 8.8, 'https://img.youtube.com/vi/1L9d3NyIt2o/hqdefault.jpg', 'https://img.youtube.com/vi/1L9d3NyIt2o/hqdefault.jpg'),
  ('34ed196b-502c-9775-ca60-0cf531b919fc'::uuid, 'KR', 2015, 'completed', 9.5, 'https://img.youtube.com/vi/HIhjLnNjBXY/hqdefault.jpg', 'https://img.youtube.com/vi/HIhjLnNjBXY/hqdefault.jpg')
on conflict (id) do nothing;

insert into public.drama_translations (drama_id, locale, title, description) values
  ('00563caa-0eab-dd38-098c-76d1b8ba8511'::uuid, 'kk', 'Менің жын-перім', 'Қатал мұрагерге оның күшінен айырылған жын қорғаушы әрі серік болады.'),
  ('00563caa-0eab-dd38-098c-76d1b8ba8511'::uuid, 'ru', 'Мой демон', 'Демону с почти утраченной силой приходится заключить союз с наследницей крупной компании.'),
  ('00563caa-0eab-dd38-098c-76d1b8ba8511'::uuid, 'en', 'My Demon', 'A demon who has nearly lost his powers becomes protector and partner to a formidable heiress.'),
  ('597d162b-19c4-5910-14d8-f93eb4b65b85'::uuid, 'kk', 'Менің атым', 'Әкесінің өлімінен кейін жас әйел қылмыстық топқа қосылып, полицияға жасырын қызмет етеді.'),
  ('597d162b-19c4-5910-14d8-f93eb4b65b85'::uuid, 'ru', 'Моё имя', 'После гибели отца девушка вступает в преступную группировку и внедряется в полицию.'),
  ('597d162b-19c4-5910-14d8-f93eb4b65b85'::uuid, 'en', 'My Name', 'After her father is killed, a young woman joins a crime syndicate and infiltrates the police.'),
  ('1d358aa4-82d7-e125-bc88-62275ade2ff3'::uuid, 'kk', 'Тәтті үй', 'Тұрғын үй кешенінің адамдары қорқынышты құбыжықтардан аман қалу үшін бірігеді.'),
  ('1d358aa4-82d7-e125-bc88-62275ade2ff3'::uuid, 'ru', 'Милый дом', 'Жильцы многоэтажки объединяются, чтобы выжить, когда люди вокруг превращаются в чудовищ.'),
  ('1d358aa4-82d7-e125-bc88-62275ade2ff3'::uuid, 'en', 'Sweet Home', 'Residents of an apartment building band together to survive as people transform into monsters.'),
  ('aaa8f3c5-26a4-80b1-0f02-8b7d0d654bc4'::uuid, 'kk', 'Даңқ', 'Мектептегі зорлықтан аман қалған әйел жылдар бойы кек жоспарын дайындайды.'),
  ('aaa8f3c5-26a4-80b1-0f02-8b7d0d654bc4'::uuid, 'ru', 'Слава', 'Пережившая школьную травлю женщина годами готовит план возмездия.'),
  ('aaa8f3c5-26a4-80b1-0f02-8b7d0d654bc4'::uuid, 'en', 'The Glory', 'A woman who survived severe school bullying spends years preparing her revenge.'),
  ('cb9b6d55-664a-4d73-656f-26dbb8be6b1c'::uuid, 'kk', 'Хатшы Кимге не болды?', 'Мінсіз хатшы жұмыстан кететінін айтқанда, өзімшіл басшысы оның себебін түсінуге тырысады.'),
  ('cb9b6d55-664a-4d73-656f-26dbb8be6b1c'::uuid, 'ru', 'Что случилось с секретарём Ким?', 'Когда идеальная секретарь решает уволиться, её самоуверенный начальник пытается понять почему.'),
  ('cb9b6d55-664a-4d73-656f-26dbb8be6b1c'::uuid, 'en', 'What’s Wrong with Secretary Kim', 'When a capable secretary plans to resign, her self-absorbed boss tries to understand why.'),
  ('b078ae85-6e4f-2920-e536-394eacb54b71'::uuid, 'kk', 'Жиырма бес, жиырма бір', 'Дағдарыс кезіндегі жас семсерлесуші мен еңбекқор жігіт достық пен алғашқы махаббатты бірге бастан кешіреді.'),
  ('b078ae85-6e4f-2920-e536-394eacb54b71'::uuid, 'ru', 'Двадцать пять, двадцать один', 'Юная фехтовальщица и целеустремлённый парень взрослеют и влюбляются на фоне экономического кризиса.'),
  ('b078ae85-6e4f-2920-e536-394eacb54b71'::uuid, 'en', 'Twenty-Five Twenty-One', 'A young fencer and a determined young man grow up and fall in love during an economic crisis.'),
  ('ef310ad3-b1ed-c880-e0bc-4f3763f61945'::uuid, 'kk', 'Теңіз жағасындағы ауыл', 'Теңіз жағасындағы ауылда тіс дәрігері мен қолынан бәрі келетін жергілікті тұрғын жақындай түседі.'),
  ('ef310ad3-b1ed-c880-e0bc-4f3763f61945'::uuid, 'ru', 'Приморская деревня Ча-ча-ча', 'В приморской деревне стоматолог знакомится с мастером на все руки и постепенно находит своё место.'),
  ('ef310ad3-b1ed-c880-e0bc-4f3763f61945'::uuid, 'en', 'Hometown Cha-Cha-Cha', 'A dentist in a seaside village grows close to a resourceful local and finds a sense of belonging.'),
  ('e8ac7333-f413-ee4a-5400-57ccfb6bbeff'::uuid, 'kk', 'Стартап', 'Жас кәсіпкерлер технологиялық компания құрып, армандары мен сезімдері үшін бәсекеге түседі.'),
  ('e8ac7333-f413-ee4a-5400-57ccfb6bbeff'::uuid, 'ru', 'Стартап', 'Молодые предприниматели строят технологические компании и ищут своё место в мире стартапов.'),
  ('e8ac7333-f413-ee4a-5400-57ccfb6bbeff'::uuid, 'en', 'Start-Up', 'Young entrepreneurs build technology companies while pursuing their ambitions and relationships.'),
  ('40a1b2d0-0d23-130a-52dc-a2221523dc00'::uuid, 'kk', 'Ерекше адвокат У Ён У', 'Аутизм спектріндегі жас заңгер ерекше есте сақтау қабілеті мен өзіндік көзқарасын сотта қолданады.'),
  ('40a1b2d0-0d23-130a-52dc-a2221523dc00'::uuid, 'ru', 'Необычный адвокат У Ён У', 'Молодой юрист с аутизмом использует выдающуюся память и нестандартный взгляд в сложных делах.'),
  ('40a1b2d0-0d23-130a-52dc-a2221523dc00'::uuid, 'en', 'Extraordinary Attorney Woo', 'A young autistic lawyer draws on her remarkable memory and fresh perspective to handle complex cases.'),
  ('bd3d3d3a-df98-df03-5372-8fcb74e6e6f0'::uuid, 'kk', 'Сен келген уақыт', 'Қайғыдан айыға алмай жүрген әйел уақытты артқа шегіндіріп, бейтаныс жасөспірімнің денесінде оянады.'),
  ('bd3d3d3a-df98-df03-5372-8fcb74e6e6f0'::uuid, 'ru', 'Время позвать тебя', 'Женщина, переживающая утрату, переносится в прошлое и просыпается в теле незнакомой школьницы.'),
  ('bd3d3d3a-df98-df03-5372-8fcb74e6e6f0'::uuid, 'en', 'A Time Called You', 'Grieving a loss, a woman travels back in time and awakens in the body of a high school student.'),
  ('3bb5ca78-1d3c-20fe-7263-85b7fc4044fb'::uuid, 'kk', 'Біздің сүйікті жазымыз', 'Мектепте бірге түсірілген деректі фильмнен кейін бұрынғы жұп қайта қауышып, өткенін жаңаша түсінеді.'),
  ('3bb5ca78-1d3c-20fe-7263-85b7fc4044fb'::uuid, 'ru', 'Наше любимое лето', 'Бывшие возлюбленные снова встречаются спустя годы после школьного документального фильма о них.'),
  ('3bb5ca78-1d3c-20fe-7263-85b7fc4044fb'::uuid, 'en', 'Our Beloved Summer', 'Former sweethearts reunite years after a school documentary unexpectedly brings them back into each other’s lives.'),
  ('4af79641-1f66-b691-6bcd-9e7c2719ec16'::uuid, 'kk', 'Аурухана плейлисті', 'Бірге оқыған бес дәрігер ауруханада жұмыс істеп, музыка мен күнделікті өмірді бөліседі.'),
  ('4af79641-1f66-b691-6bcd-9e7c2719ec16'::uuid, 'ru', 'Мудрая жизнь в больнице', 'Пятеро друзей-врачей со студенческих лет работают в одной больнице и собираются ради музыки.'),
  ('4af79641-1f66-b691-6bcd-9e7c2719ec16'::uuid, 'en', 'Hospital Playlist', 'Five friends who studied medicine together work at one hospital and share music beyond their shifts.'),
  ('0626c54d-c154-5885-7051-5dd91cf3c2f2'::uuid, 'kk', 'Жақсы жаман ана', 'Апаттан кейін жадысы мен мінезі өзгерген прокурор ауылдағы анасына қайта оралады.'),
  ('0626c54d-c154-5885-7051-5dd91cf3c2f2'::uuid, 'ru', 'Хорошая плохая мать', 'После несчастного случая прокурор теряет часть памяти и возвращается к матери в родную деревню.'),
  ('0626c54d-c154-5885-7051-5dd91cf3c2f2'::uuid, 'en', 'The Good Bad Mother', 'After an accident changes his memory, a prosecutor returns to his mother and their rural home.'),
  ('619ded35-8caa-ecdf-adca-2d9cb8a9f731'::uuid, 'kk', 'Бәріміз өлдік', 'Мектепте індет тарағанда, оқушылар тірі қалу үшін ғимараттан шығудың жолын іздейді.'),
  ('619ded35-8caa-ecdf-adca-2d9cb8a9f731'::uuid, 'ru', 'Мы все мертвы', 'Во время вспышки инфекции ученики оказываются заперты в школе и ищут путь к спасению.'),
  ('619ded35-8caa-ecdf-adca-2d9cb8a9f731'::uuid, 'en', 'All of Us Are Dead', 'When an outbreak traps students inside their school, they search for a way to survive.'),
  ('23197a5b-81c5-b746-2ef5-81bab95cc4aa'::uuid, 'kk', 'Тыныш теңіз', 'Айдағы қараусыз қалған станцияға жіберілген топ жоғалған зерттеу миссиясының құпиясын ашады.'),
  ('23197a5b-81c5-b746-2ef5-81bab95cc4aa'::uuid, 'ru', 'Море Спокойствия', 'Экипаж на Луне прибывает на заброшенную станцию, чтобы выяснить, почему провалилась прежняя миссия.'),
  ('23197a5b-81c5-b746-2ef5-81bab95cc4aa'::uuid, 'en', 'The Silent Sea', 'A lunar crew investigates an abandoned station to learn what happened to an earlier research mission.'),
  ('841ad032-e68e-0c52-4591-8cffb2ded48a'::uuid, 'kk', 'Кәмелетке толмағандар соты', 'Кәмелетке толмағандар сотының қатал судьясы әр істің артындағы себептермен бетпе-бет келеді.'),
  ('841ad032-e68e-0c52-4591-8cffb2ded48a'::uuid, 'ru', 'Суд по делам несовершеннолетних', 'Строгая судья суда по делам несовершеннолетних рассматривает сложные дела и их причины.'),
  ('841ad032-e68e-0c52-4591-8cffb2ded48a'::uuid, 'en', 'Juvenile Justice', 'A stern juvenile court judge confronts difficult cases and the circumstances behind them.'),
  ('c5afc68c-554d-408f-fe55-9439439d4bdd'::uuid, 'kk', 'Бетперделі қыз', 'Күндіз кеңседе жұмыс істейтін әйел түнде бетперде киіп, интернетте өнер көрсетеді.'),
  ('c5afc68c-554d-408f-fe55-9439439d4bdd'::uuid, 'ru', 'Девушка в маске', 'Неуверенная в себе офисная сотрудница по ночам выступает в интернете под маской.'),
  ('c5afc68c-554d-408f-fe55-9439439d4bdd'::uuid, 'en', 'Mask Girl', 'An insecure office worker performs online at night behind a mask.'),
  ('dd53b4ef-f377-ffd8-cec3-04fad2ffd6e5'::uuid, 'kk', 'Атақ', 'Әлеуметтік желі әлеміне енген әйел танымалдық, бәсеке және оның жасырын құнын көреді.'),
  ('dd53b4ef-f377-ffd8-cec3-04fad2ffd6e5'::uuid, 'ru', 'Селебрити', 'Попав в мир инфлюенсеров, женщина сталкивается с конкуренцией, славой и её скрытой ценой.'),
  ('dd53b4ef-f377-ffd8-cec3-04fad2ffd6e5'::uuid, 'en', 'Celebrity', 'A woman enters the influencer scene and discovers the competition and hidden cost of fame.'),
  ('6c5c2124-7beb-26a3-0e7a-7a98725ed130'::uuid, 'kk', 'Тылсым аңшылар', 'Күндіз кеспе сататын, түнде зұлым рухтарды іздейтін топ қала тұрғындарын қорғайды.'),
  ('6c5c2124-7beb-26a3-0e7a-7a98725ed130'::uuid, 'ru', 'Необычный счётчик', 'Днём команда работает в закусочной, а ночью охотится на злых духов и защищает город.'),
  ('6c5c2124-7beb-26a3-0e7a-7a98725ed130'::uuid, 'en', 'The Uncanny Counter', 'By day they run a noodle shop; by night they hunt evil spirits and protect their city.'),
  ('013b3fd2-dcb4-4cd6-0bb8-9376499ba85c'::uuid, 'kk', 'Винченцо', 'Италиялық адвокат Кореяға оралып, жергілікті тұрғындармен бірге қуатты корпорацияға қарсы тұрады.'),
  ('013b3fd2-dcb4-4cd6-0bb8-9376499ba85c'::uuid, 'ru', 'Винченцо', 'Итальянский адвокат возвращается в Корею и вместе с жильцами района противостоит корпорации.'),
  ('013b3fd2-dcb4-4cd6-0bb8-9376499ba85c'::uuid, 'en', 'Vincenzo', 'An Italian lawyer returns to Korea and joins local residents in taking on a powerful corporation.'),
  ('d2cf0811-1d32-6536-eaeb-60c3e2241702'::uuid, 'kk', 'Кальмар ойыны', 'Қарызға батқан адамдар үлкен жүлде үшін балалар ойындарына қатысып, қауіпті сынақтан өтеді.'),
  ('d2cf0811-1d32-6536-eaeb-60c3e2241702'::uuid, 'ru', 'Игра в кальмара', 'Люди с долгами участвуют в детских играх ради крупного приза, не зная всей опасности испытаний.'),
  ('d2cf0811-1d32-6536-eaeb-60c3e2241702'::uuid, 'en', 'Squid Game', 'People in debt enter children’s games for a large prize, unaware of the full danger of the contest.'),
  ('76bb6cc9-c68d-38f3-6519-a48f14792f4c'::uuid, 'kk', 'Король жері', 'Қонақүй мұрагері мен шынайы күлкісімен танылған қызметкер бір-бірінің өміріне өзгеше әсер етеді.'),
  ('76bb6cc9-c68d-38f3-6519-a48f14792f4c'::uuid, 'ru', 'Король земли', 'Наследник отеля и сотрудница, известная своей искренней улыбкой, постепенно сближаются.'),
  ('76bb6cc9-c68d-38f3-6519-a48f14792f4c'::uuid, 'en', 'King the Land', 'A hotel heir and an employee known for her sincere smile gradually change each other’s lives.'),
  ('d01520a6-237a-76c5-8fd3-d1513fbbc32c'::uuid, 'kk', 'Соған қарамастан', 'Махаббатқа күмәнмен қарайтын өнер студенттері жақындық пен тәуелсіздіктің арасын табуға тырысады.'),
  ('d01520a6-237a-76c5-8fd3-d1513fbbc32c'::uuid, 'ru', 'Тем не менее', 'Студенты художественного факультета ищут баланс между близостью и независимостью.'),
  ('d01520a6-237a-76c5-8fd3-d1513fbbc32c'::uuid, 'en', 'Nevertheless', 'Art students who doubt love try to balance intimacy, attraction and independence.'),
  ('52527621-94e9-7ad9-c71d-22b4c2b105a3'::uuid, 'kk', 'Бәрі жақсы болмауы да мүмкін', 'Балалар бөлімінде істейтін қамқоршы мен ертегі жазушы әйел жараларын бірге жеңуге үйренеді.'),
  ('52527621-94e9-7ad9-c71d-22b4c2b105a3'::uuid, 'ru', 'Псих, но всё в порядке', 'Работник детского отделения и писательница сказок помогают друг другу справляться с прошлым.'),
  ('52527621-94e9-7ad9-c71d-22b4c2b105a3'::uuid, 'en', 'It’s Okay to Not Be Okay', 'A caregiver in a psychiatric ward and a children’s author learn to face their past together.'),
  ('c7fba6e6-4e26-5c2c-8fbe-d9f538b9ec51'::uuid, 'kk', 'Итэвон класы', 'Жас жігіт өзі құрған мейрамхананы дамытып, ықпалды тағам компаниясымен күреседі.'),
  ('c7fba6e6-4e26-5c2c-8fbe-d9f538b9ec51'::uuid, 'ru', 'Итэвон класс', 'Молодой предприниматель развивает ресторан и бросает вызов могущественной пищевой корпорации.'),
  ('c7fba6e6-4e26-5c2c-8fbe-d9f538b9ec51'::uuid, 'en', 'Itaewon Class', 'A young entrepreneur builds his restaurant business and challenges a powerful food corporation.'),
  ('0459e8bd-83bf-6065-df94-1a03c222aff6'::uuid, 'kk', 'Сегіз шоу', 'Сегіз бейтаныс адам жабық ғимаратта уақыт өткен сайын ақша табатын ойынға қатысады.'),
  ('0459e8bd-83bf-6065-df94-1a03c222aff6'::uuid, 'ru', 'Игра в деньги', 'Восемь незнакомцев участвуют в игре, где время приносит деньги, а правила ставят их друг против друга.'),
  ('0459e8bd-83bf-6065-df94-1a03c222aff6'::uuid, 'en', 'The 8 Show', 'Eight strangers enter a closed contest where time earns money and the rules pit them against each other.'),
  ('e20fe09c-1cd9-3b93-3bf9-913fd75c7a20'::uuid, 'kk', 'Кёнсон жаратылысы', '1945 жылғы Кёнсонда кәсіпкер мен із кесуші жоғалған адамдарды іздеп жүріп, қауіпті құпияға тап болады.'),
  ('e20fe09c-1cd9-3b93-3bf9-913fd75c7a20'::uuid, 'ru', 'Существо Кёнсона', 'В Кёнсоне 1945 года предприниматель и сыщица ищут пропавших людей и сталкиваются с опасной тайной.'),
  ('e20fe09c-1cd9-3b93-3bf9-913fd75c7a20'::uuid, 'en', 'Gyeongseong Creature', 'In 1945 Gyeongseong, an entrepreneur and a sleuth search for missing people and uncover a dangerous secret.'),
  ('96a2ec0f-7706-6d6c-991a-1b8c7cb8c382'::uuid, 'kk', 'Сиқыр әуені', 'Қиындыққа тап болған оқушы қараусыз қалған ойын-сауық саябағында жұмбақ сиқыршымен кездеседі.'),
  ('96a2ec0f-7706-6d6c-991a-1b8c7cb8c382'::uuid, 'ru', 'Звук волшебства', 'Школьница, которой приходится рано взрослеть, встречает загадочного фокусника в заброшенном парке.'),
  ('96a2ec0f-7706-6d6c-991a-1b8c7cb8c382'::uuid, 'en', 'The Sound of Magic', 'A student forced to grow up too soon meets a mysterious magician in an abandoned amusement park.'),
  ('9b81e6f3-b58e-337a-cdcb-7e8b502b0b6b'::uuid, 'kk', 'Д.П.', 'Әскерден қашқандарды іздейтін жас сарбаздар әр адамның әскерге кетуіне әсер еткен оқиғаларды көреді.'),
  ('9b81e6f3-b58e-337a-cdcb-7e8b502b0b6b'::uuid, 'ru', 'Д.П.', 'Молодые военные, разыскивающие дезертиров, узнают истории, которые подтолкнули их к побегу.'),
  ('9b81e6f3-b58e-337a-cdcb-7e8b502b0b6b'::uuid, 'en', 'D.P.', 'Young soldiers assigned to track down deserters learn the stories that led each person to leave.'),
  ('34ed196b-502c-9775-ca60-0cf531b919fc'::uuid, 'kk', '1988-ге жауап', 'Сеулдегі бір көшеде тұратын бес отбасы достықты, отбасылық жылулықты және есеюді бірге бөліседі.'),
  ('34ed196b-502c-9775-ca60-0cf531b919fc'::uuid, 'ru', 'Вернуться в 1988', 'Пять семей с одной улицы в Сеуле делят дружбу, соседскую поддержку и повседневную жизнь.'),
  ('34ed196b-502c-9775-ca60-0cf531b919fc'::uuid, 'en', 'Reply 1988', 'Five families on one Seoul street share friendship, neighborhood warmth and the everyday moments of growing up.')
on conflict (drama_id, locale) do nothing;

with links(drama_slug, genre_slug) as (values
  ('my-demon', 'fantasy'),
  ('my-demon', 'romance'),
  ('my-demon', 'comedy'),
  ('my-name', 'action'),
  ('my-name', 'drama'),
  ('my-name', 'mystery'),
  ('sweet-home', 'fantasy'),
  ('sweet-home', 'action'),
  ('sweet-home', 'drama'),
  ('the-glory', 'drama'),
  ('the-glory', 'mystery'),
  ('the-glory', 'action'),
  ('secretary-kim', 'romance'),
  ('secretary-kim', 'comedy'),
  ('secretary-kim', 'drama'),
  ('twenty-five-twenty-one', 'romance'),
  ('twenty-five-twenty-one', 'drama'),
  ('twenty-five-twenty-one', 'family'),
  ('hometown-cha-cha-cha', 'romance'),
  ('hometown-cha-cha-cha', 'comedy'),
  ('hometown-cha-cha-cha', 'family'),
  ('start-up', 'romance'),
  ('start-up', 'drama'),
  ('start-up', 'family'),
  ('extraordinary-attorney-woo', 'drama'),
  ('extraordinary-attorney-woo', 'family'),
  ('extraordinary-attorney-woo', 'comedy'),
  ('a-time-called-you', 'fantasy'),
  ('a-time-called-you', 'romance'),
  ('a-time-called-you', 'mystery'),
  ('our-beloved-summer', 'romance'),
  ('our-beloved-summer', 'comedy'),
  ('our-beloved-summer', 'drama'),
  ('hospital-playlist', 'drama'),
  ('hospital-playlist', 'romance'),
  ('hospital-playlist', 'music'),
  ('good-bad-mother', 'family'),
  ('good-bad-mother', 'drama'),
  ('good-bad-mother', 'comedy'),
  ('all-of-us-are-dead', 'fantasy'),
  ('all-of-us-are-dead', 'action'),
  ('all-of-us-are-dead', 'drama'),
  ('the-silent-sea', 'fantasy'),
  ('the-silent-sea', 'action'),
  ('the-silent-sea', 'mystery'),
  ('juvenile-justice', 'drama'),
  ('juvenile-justice', 'mystery'),
  ('juvenile-justice', 'action'),
  ('mask-girl', 'drama'),
  ('mask-girl', 'mystery'),
  ('mask-girl', 'action'),
  ('celebrity', 'drama'),
  ('celebrity', 'mystery'),
  ('celebrity', 'romance'),
  ('uncanny-counter', 'fantasy'),
  ('uncanny-counter', 'action'),
  ('uncanny-counter', 'comedy'),
  ('vincenzo', 'action'),
  ('vincenzo', 'drama'),
  ('vincenzo', 'comedy'),
  ('squid-game', 'drama'),
  ('squid-game', 'action'),
  ('squid-game', 'mystery'),
  ('king-the-land', 'romance'),
  ('king-the-land', 'comedy'),
  ('king-the-land', 'drama'),
  ('nevertheless', 'romance'),
  ('nevertheless', 'drama'),
  ('nevertheless', 'family'),
  ('its-okay-to-not-be-okay', 'romance'),
  ('its-okay-to-not-be-okay', 'drama'),
  ('its-okay-to-not-be-okay', 'fantasy'),
  ('itaewon-class', 'drama'),
  ('itaewon-class', 'action'),
  ('itaewon-class', 'romance'),
  ('the-8-show', 'drama'),
  ('the-8-show', 'mystery'),
  ('the-8-show', 'action'),
  ('gyeongseong-creature', 'fantasy'),
  ('gyeongseong-creature', 'action'),
  ('gyeongseong-creature', 'mystery'),
  ('sound-of-magic', 'music'),
  ('sound-of-magic', 'fantasy'),
  ('sound-of-magic', 'drama'),
  ('dp', 'drama'),
  ('dp', 'action'),
  ('dp', 'family'),
  ('reply-1988', 'family'),
  ('reply-1988', 'drama'),
  ('reply-1988', 'romance')
)
insert into public.drama_genres (drama_id, genre_id)
select md5('dorama:' || links.drama_slug)::uuid, md5('genre:' || links.genre_slug)::uuid
from links
on conflict do nothing;

with seed_episodes(drama_slug, episode_count) as (values
  ('my-demon', 16),
  ('my-name', 8),
  ('sweet-home', 10),
  ('the-glory', 16),
  ('secretary-kim', 16),
  ('twenty-five-twenty-one', 16),
  ('hometown-cha-cha-cha', 16),
  ('start-up', 16),
  ('extraordinary-attorney-woo', 16),
  ('a-time-called-you', 12),
  ('our-beloved-summer', 16),
  ('hospital-playlist', 12),
  ('good-bad-mother', 14),
  ('all-of-us-are-dead', 12),
  ('the-silent-sea', 8),
  ('juvenile-justice', 10),
  ('mask-girl', 7),
  ('celebrity', 12),
  ('uncanny-counter', 16),
  ('vincenzo', 20),
  ('squid-game', 9),
  ('king-the-land', 16),
  ('nevertheless', 10),
  ('its-okay-to-not-be-okay', 16),
  ('itaewon-class', 16),
  ('the-8-show', 8),
  ('gyeongseong-creature', 10),
  ('sound-of-magic', 6),
  ('dp', 6),
  ('reply-1988', 20))
insert into public.episodes (id, drama_id, number, youtube_video_id, thumbnail_url)
select md5('episode:' || s.drama_slug || ':' || n)::uuid, md5('dorama:' || s.drama_slug)::uuid, n, null, null
from seed_episodes s cross join lateral generate_series(1, s.episode_count) n
on conflict (drama_id, number) do nothing;

with seed_episodes(drama_slug, episode_count) as (values
  ('my-demon', 16),
  ('my-name', 8),
  ('sweet-home', 10),
  ('the-glory', 16),
  ('secretary-kim', 16),
  ('twenty-five-twenty-one', 16),
  ('hometown-cha-cha-cha', 16),
  ('start-up', 16),
  ('extraordinary-attorney-woo', 16),
  ('a-time-called-you', 12),
  ('our-beloved-summer', 16),
  ('hospital-playlist', 12),
  ('good-bad-mother', 14),
  ('all-of-us-are-dead', 12),
  ('the-silent-sea', 8),
  ('juvenile-justice', 10),
  ('mask-girl', 7),
  ('celebrity', 12),
  ('uncanny-counter', 16),
  ('vincenzo', 20),
  ('squid-game', 9),
  ('king-the-land', 16),
  ('nevertheless', 10),
  ('its-okay-to-not-be-okay', 16),
  ('itaewon-class', 16),
  ('the-8-show', 8),
  ('gyeongseong-creature', 10),
  ('sound-of-magic', 6),
  ('dp', 6),
  ('reply-1988', 20)), locales(locale) as (values ('kk'), ('ru'), ('en'))
insert into public.episode_translations (episode_id, locale, title)
select md5('episode:' || s.drama_slug || ':' || n)::uuid, locales.locale,
       case locales.locale when 'kk' then n::text || '-серия' when 'ru' then 'Серия ' || n::text else 'Episode ' || n::text end
from seed_episodes s cross join lateral generate_series(1, s.episode_count) n cross join locales
on conflict (episode_id, locale) do nothing;
