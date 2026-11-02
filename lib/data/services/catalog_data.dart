import 'package:flutter/material.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/services/catalog_additions.dart';

class CatalogData {
  static final dramas = <Drama>[
    const Drama(
        id: 'hidden-love',
        title: 'Hidden Love',
        originalTitle: '偷偷藏不住',
        country: 'Китай',
        year: 2023,
        genre: 'Романтика',
        episodes: 25,
        score: 9.4,
        symbol: '✿',
        start: Color(0xFFEDAAB1),
        end: Color(0xFF925A8A),
        description:
            'Нежная история о первой влюблённости, взрослении и чувствах, которые сложно выразить словами.',
        translations: {
          'kk': {
            'title': 'Жасырын махаббат',
            'description': 'Сан Чжидің ағасының досына деген үнсіз сезімі жылдар өте келе өзара құрмет пен нәзік махаббатқа ұласады.',
          },
          'ru': {
            'title': 'Скрытая любовь',
            'description': 'Тихая влюблённость Сан Чжи в друга брата взрослеет вместе с ней и со временем становится взаимным чувством.',
          },
          'en': {
            'title': 'Hidden Love',
            'description': 'Sang Zhi quietly falls for her brother’s friend; years later, growing up gives their gentle connection room to become mutual.',
          },
        }),
    const Drama(
        id: 'dream-high',
        title: 'Dream High',
        originalTitle: '드림하이',
        country: 'Корея',
        year: 2011,
        genre: 'Музыка',
        episodes: 16,
        score: 9.1,
        symbol: '♫',
        start: Color(0xFF68B7C3),
        end: Color(0xFF343D83),
        description:
            'Шестеро талантливых учеников школы искусств идут к мечте о сцене, дружбе и первой любви.',
        translations: {
          'kk': {
            'title': 'Арманға ұмтыл',
            'description': 'Өнер мектебінің алты оқушысы музыка, достық және табандылық арқылы сахнаға шығуды армандайды.',
          },
          'ru': {
            'title': 'Одержимые мечтой',
            'description': 'Шесть учеников школы искусств идут к сцене через музыку, дружбу, соперничество и упорную работу.',
          },
          'en': {
            'title': 'Dream High',
            'description': 'Six students at an arts school pursue the stage through music, friendship, rivalry and hard work.',
          },
        }),
    const Drama(
        id: 'queen-tears',
        title: 'Queen of Tears',
        originalTitle: '눈물의 여왕',
        country: 'Корея',
        year: 2024,
        genre: 'Романтика',
        episodes: 16,
        score: 9.3,
        symbol: '◇',
        start: Color(0xFF7CAAC7),
        end: Color(0xFF6A618D),
        description:
            'Пара, потерявшая общий язык, получает шанс вновь узнать друг друга и сохранить свою историю.',
        translations: {
          'kk': {
            'title': 'Көз жасының патшайымы',
            'description': 'Қиын кезеңді бастан өткерген ерлі-зайыптылар бір-бірін қайта танып, бірге құрған өмірін сақтап қалуға тырысады.',
          },
          'ru': {
            'title': 'Королева слёз',
            'description': 'Супруги, переживающие кризис, заново учатся слышать друг друга и защищать совместную жизнь.',
          },
          'en': {
            'title': 'Queen of Tears',
            'description': 'A married couple facing a crisis learn to listen to each other again and fight for the life they built.',
          },
        }),
    const Drama(
        id: 'when-i-fly',
        title: 'When I Fly Towards You',
        originalTitle: '当我飞奔向你',
        country: 'Китай',
        year: 2023,
        genre: 'Комедия',
        episodes: 24,
        score: 9.2,
        symbol: '☼',
        start: Color(0xFFF4B99D),
        end: Color(0xFFDE7F83),
        description:
            'Тёплая школьная история о дружбе, смелости и маленьких моментах большого счастья.',
        translations: {
          'kk': {
            'title': 'Саған қарай ұшамын',
            'description': 'Жарқын мінезді қыз бен тұйық сыныптасының мектеп жылдарынан басталған достығы есейген сайын тереңдей түседі.',
          },
          'ru': {
            'title': 'Когда я лечу к тебе',
            'description': 'Дружба энергичной школьницы и её сдержанного одноклассника постепенно превращается в нежную историю взросления.',
          },
          'en': {
            'title': 'When I Fly Towards You',
            'description': 'An outgoing student and her reserved classmate grow from school friends into a tender story about growing up.',
          },
        }),
    const Drama(
        id: 'goblin',
        title: 'Guardian: The Lonely and Great God',
        originalTitle: '쓸쓸하고 찬란하神 – 도깨비',
        country: 'Корея',
        year: 2016,
        genre: 'Фэнтези',
        episodes: 16,
        score: 9.5,
        symbol: '✦',
        start: Color(0xFF9F9BC8),
        end: Color(0xFF53638C),
        description:
            'Бессмертный хранитель встречает девушку, способную изменить судьбу. Волшебство, юмор и выбор сердца.',
        translations: {
          'kk': {
            'title': 'Гоблин',
            'description': 'Өлмейтін жауынгердің қарғысын тек қалыңдығы бұза алады; олардың жолында өлім періштесі мен батыл қыз кездеседі.',
          },
          'ru': {
            'title': 'Токкэби',
            'description': 'Проклятие бессмертного воина может снять только его невеста; на их пути появляются жнец душ и смелая девушка.',
          },
          'en': {
            'title': 'Guardian: The Lonely and Great God',
            'description': 'Only the immortal warrior’s bride can end his curse, drawing a grim reaper and a spirited young woman into their lives.',
          },
        }),
    const Drama(
        id: 'love-o2o',
        title: 'Love O2O',
        originalTitle: '微微一笑很倾城',
        country: 'Китай',
        year: 2016,
        genre: 'Романтика',
        episodes: 30,
        score: 8.9,
        symbol: '♡',
        start: Color(0xFFF7B4BE),
        end: Color(0xFFAB809D),
        description:
            'Два игрока знакомятся в онлайн-игре, а их история неожиданно продолжается в реальном мире.',
        translations: {
          'kk': {
            'title': 'Махаббат онлайн',
            'description': 'Онлайн ойында танысқан екі студент виртуалды әлемдегі серіктестіктің шынайы өмірде де жалғасатынын байқайды.',
          },
          'ru': {
            'title': 'Любовь онлайн',
            'description': 'Двое студентов знакомятся в сетевой игре и обнаруживают, что виртуальное партнёрство продолжается в реальной жизни.',
          },
          'en': {
            'title': 'Love O2O',
            'description': 'Two university students meet through an online game and discover their virtual partnership carries into everyday life.',
          },
        }),
    const Drama(
        id: 'business-proposal',
        title: 'Business Proposal',
        originalTitle: '사내 맞선',
        country: 'Корея',
        year: 2022,
        genre: 'Комедия',
        episodes: 12,
        score: 9.0,
        symbol: '❀',
        start: Color(0xFF8BCDC7),
        end: Color(0xFF5487B6),
        description:
            'Фальшивое свидание приводит к настоящим чувствам в остроумной офисной романтической комедии.',
        translations: {
          'kk': {
            'title': 'Іскерлік ұсыныс',
            'description': 'Досының орнына кездесуге барған қызметкер өз компаниясының басшысымен танысып, ойдан шығарылған романтикаға кіріседі.',
          },
          'ru': {
            'title': 'Деловое предложение',
            'description': 'Сотрудница идёт на свидание вместо подруги и неожиданно встречает директора собственной компании.',
          },
          'en': {
            'title': 'Business Proposal',
            'description': 'An employee takes her friend’s place on a blind date and finds herself facing the CEO of her own company.',
          },
        }),
    ...CatalogAdditions.dramas,
  ];

  static Drama byId(String id) =>
      dramas.firstWhere((d) => d.id == id, orElse: () => dramas.first);

  static final sampleReviews = <DramaReview>[
    DramaReview(
        id: 'sample-1',
        dramaId: 'hidden-love',
        author: 'sora.moon',
        stars: 5,
        content:
            'Такая уютная история! Особенно понравилась химия главных героев и тёплая атмосфера.',
        spoiler: false,
        mine: false,
        createdAt: DateTime(2026, 10, 21)),
    DramaReview(
        id: 'sample-2',
        dramaId: 'hidden-love',
        author: 'kdrama.diary',
        stars: 4,
        content:
            'Мне очень понравилось развитие отношений, а финальные серии заставили улыбаться. Спойлер: герои наконец-то честно поговорили.',
        spoiler: true,
        mine: false,
        createdAt: DateTime(2026, 10, 20)),
    DramaReview(
        id: 'sample-3',
        dramaId: 'dream-high',
        author: 'music.love',
        stars: 5,
        content:
            'Музыка и стремление к мечте вдохновляют пересматривать снова!',
        spoiler: false,
        mine: false,
        createdAt: DateTime(2026, 10, 18)),
  ];
}
