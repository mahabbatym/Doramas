# DoramaNest ♡ 

**Flutter мобильді қосымшасы** · Figma-дағы `DoramaNest — Practical 2 | Mobile UI` дизайны негізінде.

**Figma:** https://www.figma.com/design/pY6D065uTGpoD2w0TwANdL/DoramaNest-%E2%80%94-Practical-2-%7C-Mobile-UI?node-id=4-2

Түстер: `#F8FBFF`, `#25344B`, `#478FBD`, `#E8F3FD`, `#FFEDE6`. Figma-дағы иллюстрациялық постерлер Flutter-native градиенттер және пішіндермен қайта құрылды. Қараңғы режим де бар.

## Жылдам іске қосу (macOS)

1. ZIP-ті аш. MacBook-та Flutter SDK орнатылғанын тексер: `flutter doctor`.
2. Терминалдан жоба папкасына өт:

   ```bash
   cd ~/Downloads/DoramaNest_Flutter
   ```

3. Осы checkout-та iOS runner бар, ал Android runner әлі жоқ. Android-та іске қосатын болсаң, алдымен:

   ```bash
   flutter create . --project-name dorama_nest --org com.doramanest --platforms=android
   flutter pub get
   ```

   Немесе `bash scripts/setup.command` орындасаң, ол тек Android runner-ді scaffold жасап, `analyze` мен `test` іске қосады.

4. Тексер, іске қос:

   ```bash
   flutter analyze
   flutter test
   flutter run
   ```

   iPhone таңдасаң, Xcode-тың `Signing & Capabilities` ішінен өз Apple Team-іңді таңда. iOS-қа CocoaPods қажет болуы мүмкін.

> `flutter create .` тек платформалық runner файлдарын генерациялау үшін қажет. `lib/` ішінде негізгі қосымша коды толық қамтылған. Егер команда existing files overwrite сұраса, жобадағы `lib/` пен `pubspec.yaml` файлдарын сақта; `--overwrite` қолданба.

## Функциялар

- Figma бойынша Splash + екі onboarding экраны.
- Login / Registration: email, password, nickname және келісім validation.
- Home, Catalog, Drama detail, Reviews, Create review, Edit review, Search, Favorites, Profile, Settings.
- Бес бөлімді жұмыс істейтін Bottom Navigation.
- Жергілікті каталогта 37, Supabase seed каталогында 42 корей және қытай дорамасы бар; ел/жанр бойынша фильтр, іздеу және жеке карточкалар.
- 1–5 жұлдыз, пікір жазу/өңдеу/жою; спойлердің мәтінін жасыру, қолмен ашу.
- SQLite (`sqflite`) каталогты, пікірлерді, таңдаулыларды және көру прогресін құрылғыда сақтайды; профиль мен баптаулар `shared_preferences` ішінде қалады.
- Каталогқа өз дорамаңды қосуға, өзгертуге және жоюға болады. Сервер конфигурацияланбаса, CRUD жергілікті каталогта жұмыс істейді.
- `Продолжить просмотр` үй экранына көру прогресін шығарады; келесі серияны белгілеу офлайн жұмыс істейді.
- Қараңғы режим, animations, snackbar, dialog, empty state, scroll-based responsive UI.
- Supabase/PostgREST GET, POST, PATCH, DELETE, анонимді сессия, admin-only каталог жазбалары, favorites және SharedPreferences-тағы каталог кэші Practical #5 деректер қабатын береді.
- Каталогтағы 30 жаңа корей дорамасының постерлері мен фондарында ресми YouTube трейлер нобайлары қолданылады; диск кэші мен брендтелген fallback бар.
- Қазіргі жобада ресми YouTube эпизод сілтемелері жоқ. SQL seed оларды ойдан қоспайды; видео енгізілген жоқ.
- Unit coverage includes the REST client, Supabase repository, locale fallback, catalog filters/sorting, SQLite repository and validators; a splash navigation smoke test covers the app entry flow.

## Навигация

`Splash -> Onboarding 1 -> Onboarding 2 -> Login/Register -> MainShell`

`MainShell: Home | Catalog | Search | Favorites | Profile`

`Home/Catalog/Search/Favorites -> Drama Detail -> Reviews -> Create/Edit Review`

`Profile -> Settings -> Logout -> Login`

## Структура

```text
lib/
  main.dart
  core/
    l10n/generated/{app_localizations,...}.dart
    locale_text.dart
    theme/app_theme.dart
    validators.dart
    widgets/nest_widgets.dart
  data/
    api/{api_client,api_config,api_exception}.dart
    models/{drama,drama_api_model,review,genre,favorite,watch_progress}.dart
    services/{catalog_data,catalog_query,drama_repository,supabase_drama_repository}.dart
  state/app_controller.dart
  features/
    onboarding/welcome_screens.dart
    auth/auth_screens.dart
    home/{main_shell,home_page}.dart
    catalog/{catalog_page,drama_form_page}.dart
    drama/drama_detail_page.dart
    reviews/review_pages.dart
    search/search_page.dart
    favorites/favorites_page.dart
    profile/profile_page.dart
    settings/settings_page.dart
  l10n/{app_en,app_kk,app_ru,app_ko}.arb
test/{api_client,catalog_query,supabase_drama_repository,...}_test.dart
supabase/{01_schema,02_rls,03_seed}.sql
docs/{api_endpoints,api_testing}.md
```

## Practical work №5

Supabase жобасын және қосымша орнатуды [supabase/README.md](supabase/README.md) бөлімінен қара. Барлық PostgREST endpoint-тер [docs/api_endpoints.md](docs/api_endpoints.md) ішінде, ал бөлек GET/POST/PATCH/DELETE тексеру нұсқауы [docs/api_testing.md](docs/api_testing.md) ішінде.

`env.json` файлын `env.example.json` үлгісінен жаса. Supabase жоқ болса, app local SQLite каталогымен ашылады және конфигурация туралы баннер көрсетеді. Қазіргі login/register экрандары әлі Practical #4 демонстрациялық ағыны; cloud-та анонимді session табылса, splash пен onboarding оларды өткізіп, каталогты login экрансыз ашады.

Осы workspace-та нақты Supabase credentials, сервер жобасы және Android runner жоқ. SQL-ді Dashboard-та іске қосу, постер URL-дарын интернет арқылы тексеру және iOS/Android құрылғысында қолмен тексеру бөлек орындалады.

### Қалған функционалдық шектеулер

Қолданыстағы пікірлер мен login/register validation-ы серверге көшірілген жоқ. Cast кестелері бар, бірақ detail UI актерлерді және in-app ойнатқышты көрсетпейді. Жаңа дорамалардың постерлері трейлер нобайларын қолданады; толық серияға арналған YouTube video IDs әзірге null. `scripts/check_seed_urls.py` seed ішіндегі сурет сілтемелерін тексереді.

### SQLite және миграция

SQLite схема нұсқасы `6`; database access `lib/data/services/drama_repository.dart` ішінде оқшауланған. Бірінші іске қосуда каталог пен үлгі пікірлер қосылады. Ескі `favorites` және `ownReviews` preference мәндері `sqliteMigrationV1` кілті арқылы SQLite-ке бір рет көшіріледі. Settings/preferences бұрынғыдай SharedPreferences-та қалады. Соңғы сервер каталогы SharedPreferences-та кэштеліп, SQLite-ке көшіріледі.

Entity-лер: `Drama`, `Genre`, `DramaReview`, `Favorite`, `WatchProgress`. Genre дорамаға, ал review/favorite/progress дорама ID-сіне байланған. Қолданушы құрған дораманы жою оның байланысты жергілікті жазбаларын foreign key каскадпен өшіреді.

Figma-да 15 негізгі экран бар; осы жоба олардың барлығына арналған Flutter экрандарын және жұмыс істейтін навигацияны қамтиды. Practical #5 өзгерістеріне `flutter pub get --offline`, `flutter analyze` және `flutter test` осы ортада орындалды; analyzer таза, барлық тест өтті. Құрылғыда және нақты Supabase жобасында тексеру әлі жасалған жоқ.

## Тапсыру

1. Mac-та іске қосып, барлық навигацияны көрсет.
2. `flutter analyze`, `flutter test` нәтижелерін скриншотқа түсір.
3. Splash, Login, Home, Catalog, Detail, Reviews, Add/Edit, Search, Favorites, Profile, Settings экрандарын Figma-мен салыстыр.
4. `PRACTICAL_4_CHECKLIST.md` ішіндегі критерийлер бойынша жобаны түсіндір.
