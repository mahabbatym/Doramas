import 'package:flutter/widgets.dart';
import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:dorama_nest/data/api/api_exception.dart';

String tx(BuildContext context, String source) {
  final strings = AppLocalizations.of(context)!;
  return switch (source) {
    "Главная" => strings.m000,
    "Каталог" => strings.m001,
    "Поиск" => strings.m002,
    "Моё" => strings.m003,
    "Профиль" => strings.m004,
    "Избранное" => strings.m005,
    "Настройки" => strings.m006,
    "Под себя ✦" => strings.m007,
    "Дорамы должны приносить только радость." => strings.m008,
    "Предпочтения" => strings.m009,
    "Тёмная тема" => strings.m010,
    "Уютная палитра для вечера" => strings.m011,
    "Уведомления" => strings.m012,
    "Настройка уведомлений" => strings.m013,
    "Показывать спойлеры" => strings.m014,
    "Сюжетные секреты под защитой" => strings.m015,
    "О приложении" => strings.m016,
    "Язык интерфейса" => strings.m017,
    "Русский" => strings.m018,
    "О DoramaNest" => strings.m019,
    "Каталог корейских и китайских дорам" => strings.m020,
    "Выйти из аккаунта" => strings.m021,
    "Выйти из аккаунта?" => strings.m022,
    "Отмена" => strings.m024,
    "Выйти" => strings.m025,
    "Мой профиль" => strings.m026,
    "Избранных" => strings.m027,
    "Моих отзывов" => strings.m028,
    "Категории" => strings.m029,
    "Моё пространство" => strings.m030,
    "Избранные дорамы" => strings.m031,
    "Любимые истории и закладки" => strings.m032,
    "Мои обсуждения" => strings.m033,
    "Отзывы и комментарии" => strings.m034,
    "Уведомления и приватность" => strings.m035,
    "Счастливые истории начинаются здесь ✦" => strings.m036,
    "Твоя коллекция дорам" => strings.m037,
    "Смотреть каталог →" => strings.m039,
    "В каталог →" => strings.m040,
    "Истории в сердце ♡" => strings.m041,
    "Всё любимое — всегда под рукой." => strings.m042,
    "Самая любимая дорама — всего в одном поиске." => strings.m044,
    "Название или жанр..." => strings.m045,
    "Результаты" => strings.m046,
    "Ничего не найдено" => strings.m047,
    "Попробуй другое название, страну или жанр." => strings.m048,
    "Очистить поиск" => strings.m049,
    "Все истории ждут своего зрителя." => strings.m051,
    "Найдено:" => strings.m052,
    "Историй пока нет" => strings.m053,
    "Попробуй выбрать другую категорию." => strings.m054,
    "Ещё больше историй ↘" => strings.m055,
    "Под настроение" => strings.m056,
    "Все →" => strings.m057,
    "Популярные истории" => strings.m058,
    "Подробнее →" => strings.m060,
    "Истории становятся ближе" => strings.m061,
    "Читай отзывы и делись эмоциями ♡" => strings.m062,
    "Романтика" => strings.m063,
    "Комедия" => strings.m064,
    "Фэнтези" => strings.m065,
    "Музыка" => strings.m066,
    "Драма" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Драма',
        'ru' => 'Драма',
        'ko' => '드라마',
        _ => 'Drama',
      },
    "Корея" => strings.m067,
    "Китай" => strings.m068,
    "Все" => strings.m069,
    "Вход" => strings.m070,
    "Регистрация" => strings.m071,
    "Войди, чтобы сохранить свои любимые истории." => strings.m073,
    "Пароль" => strings.m074,
    "Не менее 6 символов" => strings.m075,
    "Введите email и пароль" => strings.m076,
    "Забыли пароль?" => strings.m078,
    "Входим…" => strings.m079,
    "Войти →" => strings.m080,
    "или" => strings.m081,
    "Создать аккаунт" => strings.m082,
    "Примите правила приложения, чтобы продолжить" => strings.m084,
    "Создай маленький уголок для любимых дорам." => strings.m086,
    "Имя или никнейм" => strings.m087,
    "Например, dorama.mia" => strings.m088,
    "Согласна с правилами приложения" => strings.m089,
    "Создаём…" => strings.m090,
    "Создать аккаунт →" => strings.m091,
    "Уже есть аккаунт? Войти" => strings.m092,
    "Пропустить ›" => strings.m093,
    "Открыть свой мир →" => strings.m095,
    "ХИКАЯ ЖАҚСЫ КӨРЕТІНДЕРГЕ" => strings.m096,
    "Делись впечатлениями, оценивай и находи единомышленников." => strings.m099,
    "Продолжить →" => strings.m100,
    "Начать ✦" => strings.m101,
    "Отзывы о дораме" => strings.m102,
    "Эмоциями приятнее делиться." => strings.m103,
    "Оценка зрителей" => strings.m104,
    "Зрительская оценка" => strings.m104,
    "+ Мой отзыв" => strings.m105,
    "Пока нет отзывов" => strings.m106,
    "Стань первым зрителем, который поделится эмоциями." => strings.m107,
    "Действия с отзывом" => strings.m108,
    "Редактировать" => strings.m109,
    "Удалить" => strings.m110,
    "Спойлер скрыт · Показать →" => strings.m111,
    "Можно изменить ✎" => strings.m112,
    "♡ Спасибо" => strings.m113,
    "Удалить отзыв?" => strings.m114,
    "Это действие нельзя отменить." => strings.m115,
    "Отзыв удалён" => strings.m116,
    "Не удалось сохранить отзыв" => strings.m117,
    "Новый отзыв" => strings.m118,
    "Редактировать отзыв" => strings.m119,
    "Измени впечатление ✎" => strings.m120,
    "Расскажи, как тебе ✎" => strings.m121,
    "Как тебе история?" => strings.m122,
    "Не моё" => strings.m123,
    "Есть над чем подумать" => strings.m124,
    "Неплохо!" => strings.m125,
    "Очень понравилось" => strings.m126,
    "В самое сердце!" => strings.m127,
    "Твой отзыв" => strings.m128,
    "Что удивило? Какая сцена запомнилась?" => strings.m129,
    "Напиши хотя бы 10 символов" => strings.m130,
    "Максимум 1000 символов" => strings.m131,
    "Содержит спойлеры" => strings.m132,
    "Скроем текст от других зрителей" => strings.m133,
    "Отзыв опубликован ♡" => strings.m134,
    "Изменения сохранены ♡" => strings.m135,
    "О дораме" => strings.m136,
    "Изменить дораму" => strings.m137,
    "Удалить дораму" => strings.m138,
    "Обновить прогресс" => strings.m139,
    "Отметить просмотренные серии" => strings.m140,
    "Найти 1 серию ↗" => strings.m141,
    "Обсуждение" => strings.m142,
    "Отзывы зрителей и спойлеры — под контролем" => strings.m143,
    "Отзывы и оценки →" => strings.m144,
    "Не удалось открыть ссылку. Попробуй позже." => strings.m145,
    "Прогресс просмотра" => strings.m146,
    "Сохранить" => strings.m147,
    "Укажи от 1 до 500 серий." => strings.m149,
    "Не удалось сохранить" => strings.m150,
    "Новая дорама" => strings.m151,
    "Добавь историю ✧" => strings.m152,
    "Обнови детали ✎" => strings.m153,
    "Запись будет сохранена на этом устройстве." => strings.m154,
    "Название" => strings.m155,
    "Оригинальное название" => strings.m156,
    "Год" => strings.m157,
    "Серий" => strings.m158,
    "Краткое описание" => strings.m159,
    "Сохранить в библиотеку →" => strings.m160,
    "Не удалось выполнить поиск" => strings.m161,
    "Не удалось отсортировать каталог" => strings.m162,
    "Добавить дораму" => strings.m163,
    "По названию" => strings.m164,
    "Сначала новые" => strings.m165,
    "По рейтингу" => strings.m166,
    "Продолжить просмотр" => strings.m167,
    "Не удалось загрузить локальную библиотеку" => strings.m169,
    "Закрыть" => strings.m170,
    "Мои отзывы" => strings.m171,
    "DORAMA LOVER" => strings.m172,
    "DORAMANEST · ТВОЙ УЮТНЫЙ МИР" => strings.m173,
    "♡ Любимые истории сохраняются на этом устройстве." => strings.m174,
    "Не удалось сохранить избранное" => strings.m175,
    "Проверьте email и попробуйте ещё раз" => strings.m177,
    "Связанные отзывы, избранное и прогресс тоже будут удалены." =>
      strings.m182,
    "✦ ВЫБОР РЕДАКЦИИ" => strings.m183,
    "Открывай корейские и китайские дорамы в одном уютном месте." =>
      strings.m185,
    "Это поле обязательно" => strings.m186,
    "Введите email" => strings.m187,
    "Введите корректный email, например hello@example.com" => strings.m188,
    "Введите пароль" => strings.m189,
    "Пароль должен содержать минимум 6 символов" => strings.m190,
    "Введите корректный год" => strings.m191,
    "Нужно число" => strings.m192,
    "Отзыв" => strings.m193,
    "Описание" => strings.m194,
    "Имя" => strings.m195,
    "Страна" => strings.m196,
    "Email" => strings.m197,
    "Рады видеть\nтебя снова!" => strings.m198,
    "Начнём нашу\nисторию? ✨" => strings.m199,
    "Твои истории. Твои эмоции.\nТвой маленький мир дорам." => strings.m200,
    "Истории, в которых\nхочется остаться" => strings.m201,
    "Каждая дорама —\nповод обсудить" => strings.m202,
    "Моменты, которые\nостаются с нами." => strings.m203,
    "Мой отзыв" => strings.m204,
    "Сообщество DoramaNest" => strings.m205,
    "твоё мнение важно." => strings.m206,
    "🔒 Содержит спойлеры" => strings.m207,
    "Сохраняем…" => strings.m208,
    "Сохранить изменения →" => strings.m209,
    "Опубликовать отзыв →" => strings.m210,
    "Открой эту историю и поделись впечатлениями." => strings.m211,
    "Не удалось открыть YouTube. Проверь подключение и настройки." =>
      strings.m212,
    "В избранное" => strings.m213,
    "Удалить из избранного" => strings.m214,
    "Добавить в избранное" => strings.m215,
    "Убрать из избранного" => strings.m216,
    "Жанр" => strings.m217,
    "Необязательно" => strings.m218,
    "Например, My Lovely Runner" => strings.m219,
    "О чём эта история?" => strings.m220,
    "Укажи корректный год" => strings.m221,
    "Не удалось отсортировать каталог:" => strings.m225,
    "Не удалось выполнить поиск:" => strings.m226,
    "Не удалось сохранить:" => strings.m227,
    "Не удалось сохранить избранное:" => strings.m228,
    "Найдите следующую любимую историю в каталоге." => strings.m229,
    "Удалить дораму?" => strings.m230,
    "Твои избранные дорамы и отзывы останутся на этом устройстве." =>
      strings.m231,
    "Пока нет отзывов. Открой дораму и поделись впечатлением!" => strings.m232,
    "Истории, к которым хочется возвращаться" => strings.m233,
    "Подпишись на любимые истории" => strings.m234,
    "Сохраняй истории, чтобы возвращаться к ним в любой момент." =>
      strings.m038,
    "Твоя новая\nлюбовь ждёт!" => strings.m222,
    "Выбирай по\nнастроению ✧" => strings.m050,
    "Найди свою\nисторию ⌕" => strings.m237,
    "Қайталау" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Қайталау',
        'ru' => 'Повторить',
        _ => 'Retry',
      },
    "Рейтинг" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Рейтинг',
        'ru' => 'Рейтинг',
        _ => 'Rating',
      },
    "Статус" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Мәртебесі',
        'ru' => 'Статус',
        _ => 'Status',
      },
    "Укажи рейтинг от 0 до 10" => switch (
          Localizations.localeOf(context).languageCode) {
        'kk' => 'Рейтинг 0 мен 10 аралығында болуы керек',
        'ru' => 'Укажи рейтинг от 0 до 10',
        _ => 'Enter a rating from 0 to 10',
      },
    "Суреттің HTTPS сілтемесін енгізіңіз" => switch (
          Localizations.localeOf(context).languageCode) {
        'kk' => 'Суреттің дұрыс HTTPS сілтемесін енгізіңіз',
        'ru' => 'Укажите корректную HTTPS-ссылку на изображение',
        _ => 'Enter a valid HTTPS image URL',
      },
    "URL постера" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Постер сілтемесі',
        'ru' => 'URL постера',
        _ => 'Poster URL',
      },
    "URL обложки" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Мұқаба сілтемесі',
        'ru' => 'URL обложки',
        _ => 'Backdrop URL',
      },
    "Барлық елдер" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Барлық ел',
        'ru' => 'Все страны',
        _ => 'All countries',
      },
    "Все годы" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Барлық жыл',
        'ru' => 'Все годы',
        _ => 'All years',
      },
    "Все статусы" => switch (Localizations.localeOf(context).languageCode) {
        'kk' => 'Барлық мәртебе',
        'ru' => 'Все статусы',
        _ => 'All statuses',
      },
    _ => source,
  };
}

String apiStatusText(
  BuildContext context,
  ApiFailureKind? failure, {
  required bool showingSavedData,
}) {
  final locale = Localizations.localeOf(context).languageCode;
  final messages = <String, Map<String, String>>{
    'configuration': {
      'kk':
          'Supabase бапталмаған. env.json файлын жасап, қосымшаны қайта іске қосыңыз.',
      'ru':
          'Supabase не настроен. Создайте env.json и перезапустите приложение.',
      'en': 'Supabase is not configured. Add env.json and restart the app.',
    },
    'offline': {
      'kk': showingSavedData
          ? 'Интернет жоқ. Сақталған каталог көрсетіліп тұр.'
          : 'Интернет байланысын тексеріп, қайта көріңіз.',
      'ru': showingSavedData
          ? 'Нет интернета. Показан сохранённый каталог.'
          : 'Нет подключения к интернету. Проверьте сеть и повторите попытку.',
      'en': showingSavedData
          ? 'Offline. Showing the saved catalog.'
          : 'No internet connection. Check your network and retry.',
    },
    'timeout': {
      'kk': 'Серверге қосылу уақыты аяқталды. Қайталап көріңіз.',
      'ru': 'Сервер отвечает слишком долго. Попробуйте ещё раз.',
      'en': 'The server took too long to respond. Please retry.',
    },
    'unauthorized': {
      'kk': 'Авторизация сессиясы аяқталды. Қосымшаны қайта ашыңыз.',
      'ru': 'Сессия авторизации истекла. Перезапустите приложение.',
      'en': 'Your session expired. Restart the app to sign in again.',
    },
    'forbidden': {
      'kk': 'Бұл әрекетке әкімші рұқсаты қажет.',
      'ru': 'Для этого действия нужны права администратора.',
      'en': 'Administrator access is required for this action.',
    },
    'notFound': {
      'kk': 'Серверде жазба табылмады. Каталогты жаңартыңыз.',
      'ru': 'Запись не найдена на сервере. Обновите каталог.',
      'en': 'The server record was not found. Refresh the catalog.',
    },
    'conflict': {
      'kk': 'Дерек сервермен сәйкес келмейді. Каталогты жаңартыңыз.',
      'ru': 'Данные конфликтуют с сервером. Обновите каталог.',
      'en': 'The data conflicts with the server. Refresh the catalog.',
    },
    'server': {
      'kk': showingSavedData
          ? 'Сервер қатесі. Сақталған каталог көрсетіліп тұр.'
          : 'Сервер қатесі. Қайталап көріңіз.',
      'ru': showingSavedData
          ? 'Ошибка сервера. Показан сохранённый каталог.'
          : 'Ошибка сервера. Попробуйте ещё раз.',
      'en': showingSavedData
          ? 'Server error. Showing the saved catalog.'
          : 'Server error. Please retry.',
    },
    'invalidRequest': {
      'kk': 'Сұрау қабылданбады. Енгізілген деректерді тексеріңіз.',
      'ru': 'Сервер отклонил запрос. Проверьте введённые данные.',
      'en': 'The server rejected the request. Check the submitted data.',
    },
    'invalidResponse': {
      'kk': 'Сервер жауабын оқу мүмкін болмады. Кейінірек қайталап көріңіз.',
      'ru': 'Не удалось прочитать ответ сервера. Попробуйте позже.',
      'en': 'The server response could not be read. Please retry later.',
    },
    'unknown': {
      'kk': 'Сұрау орындалмады. Қайталап көріңіз.',
      'ru': 'Не удалось выполнить запрос. Попробуйте ещё раз.',
      'en': 'The request failed. Please try again.',
    },
  };
  final byLocale = messages[failure?.name ?? 'unknown'] ?? messages['unknown']!;
  return byLocale[locale] ?? byLocale['en']!;
}

String localizedDramaFieldLabel(
  BuildContext context, {
  required String locale,
  required bool description,
}) {
  final uiLocale = Localizations.localeOf(context).languageCode;
  final languageName = switch (locale) {
    'kk' => switch (uiLocale) {
        'kk' => 'Қазақша',
        'ru' => 'казахском',
        _ => 'Kazakh',
      },
    'ru' => switch (uiLocale) {
        'kk' => 'Орысша',
        'ru' => 'русском',
        _ => 'Russian',
      },
    _ => switch (uiLocale) {
        'kk' => 'Ағылшынша',
        'ru' => 'английском',
        _ => 'English',
      },
  };
  final field = switch (uiLocale) {
    'kk' => description ? 'Сипаттама' : 'Атауы',
    'ru' => description ? 'Описание' : 'Название',
    _ => description ? 'Description' : 'Title',
  };
  return '$field ($languageName)';
}

String dramaStatusLabel(BuildContext context, String status) {
  final locale = Localizations.localeOf(context).languageCode;
  const labels = {
    'announced': {
      'kk': 'Жоспарланған',
      'ru': 'Анонсирована',
      'en': 'Announced'
    },
    'ongoing': {'kk': 'Көрсетіліп жатыр', 'ru': 'Выходит', 'en': 'Ongoing'},
    'completed': {'kk': 'Аяқталған', 'ru': 'Завершена', 'en': 'Completed'},
    'released': {'kk': 'Шыққан', 'ru': 'Вышла', 'en': 'Released'},
    'hiatus': {'kk': 'Үзілісте', 'ru': 'На паузе', 'en': 'On hiatus'},
  };
  final values = labels[status] ?? labels['released']!;
  return values[locale] ?? values['en']!;
}

String episodeRange(BuildContext context, int total) =>
    AppLocalizations.of(context)!.episodeRange(total);

String resultsCount(BuildContext context, int count) =>
    AppLocalizations.of(context)!.resultsCount(count);

String reviewCount(BuildContext context, int count) =>
    AppLocalizations.of(context)!.reviewCount(count);
String episodeCountError(BuildContext context, int total) =>
    AppLocalizations.of(context)!.episodeCountError(total);
String progressComplete(BuildContext context, int total) =>
    AppLocalizations.of(context)!.progressComplete(total);
String progressNext(BuildContext context, int episode, int total) =>
    AppLocalizations.of(context)!.progressNext(episode, total);
String ratingTooltip(BuildContext context, int stars) =>
    AppLocalizations.of(context)!.ratingTooltip(stars);
String watchComplete(BuildContext context, String title) =>
    AppLocalizations.of(context)!.watchComplete(title);
String watchNext(BuildContext context, String title, int episode) =>
    AppLocalizations.of(context)!.watchNext(title, episode);
String greeting(BuildContext context, String name) =>
    AppLocalizations.of(context)!.greeting(name);
