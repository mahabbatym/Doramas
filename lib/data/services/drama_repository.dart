import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/favorite.dart';
import 'package:dorama_nest/data/models/genre.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:dorama_nest/data/services/catalog_data.dart';

class DramaRepository {
  final DatabaseFactory _factory;
  final String? _databasePath;
  Database? _database;

  DramaRepository({DatabaseFactory? factory, String? databasePath})
      : _factory = factory ?? databaseFactory,
        _databasePath = databasePath;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    final databasePath = _databasePath ??
        p.join(await _factory.getDatabasesPath(), 'dorama_nest.db');
    _database = await _factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 7,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, version) => _createSchema(db),
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''CREATE TABLE watch_progress (
              dramaId TEXT PRIMARY KEY REFERENCES dramas(id) ON DELETE CASCADE,
              episodesWatched INTEGER NOT NULL CHECK (episodesWatched >= 0),
              updatedAt TEXT NOT NULL
            )''');
          }
          if (oldVersion < 3) {
            await db.execute(
                'ALTER TABLE dramas ADD COLUMN isCustom INTEGER NOT NULL DEFAULT 0');
          }
          if (oldVersion < 4) {
            await db.execute('ALTER TABLE dramas ADD COLUMN posterUrl TEXT');
            await db.execute('ALTER TABLE dramas ADD COLUMN backdropUrl TEXT');
          }
          if (oldVersion < 5) {
            await db.execute(
                "ALTER TABLE dramas ADD COLUMN status TEXT NOT NULL DEFAULT 'released'");
          }
          if (oldVersion < 6) {
            await db.execute(
                "ALTER TABLE dramas ADD COLUMN translations TEXT NOT NULL DEFAULT '{}' ");
          }
          if (oldVersion < 7) {
            await db.execute("ALTER TABLE dramas ADD COLUMN genreSlugs TEXT NOT NULL DEFAULT '[]'");
            await db.execute("ALTER TABLE watch_progress ADD COLUMN status TEXT NOT NULL DEFAULT 'watching'");
            await db.execute("UPDATE watch_progress SET status = 'completed' WHERE episodesWatched >= (SELECT episodes FROM dramas WHERE dramas.id = watch_progress.dramaId)");
          }
        },
      ),
    );
    await _seedCatalog(_database!);
    return _database!;
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''CREATE TABLE genres (
      id TEXT PRIMARY KEY, name TEXT NOT NULL UNIQUE
    )''');
    await db.execute('''CREATE TABLE dramas (
      id TEXT PRIMARY KEY, title TEXT NOT NULL, originalTitle TEXT NOT NULL,
      country TEXT NOT NULL, year INTEGER NOT NULL, status TEXT NOT NULL DEFAULT 'released', genre TEXT NOT NULL REFERENCES genres(name),
      episodes INTEGER NOT NULL CHECK (episodes > 0), score REAL NOT NULL CHECK (score BETWEEN 0 AND 10),
      description TEXT NOT NULL, posterUrl TEXT, backdropUrl TEXT, translations TEXT NOT NULL DEFAULT '{}', symbol TEXT NOT NULL, startColor INTEGER NOT NULL, endColor INTEGER NOT NULL,
      isCustom INTEGER NOT NULL DEFAULT 0, genreSlugs TEXT NOT NULL DEFAULT '[]'
    )''');
    await db.execute(
        'CREATE INDEX dramas_title_idx ON dramas(title COLLATE NOCASE)');
    await db
        .execute('CREATE INDEX dramas_genre_year_idx ON dramas(genre, year)');
    await db.execute('''CREATE TABLE reviews (
      id TEXT PRIMARY KEY, dramaId TEXT NOT NULL REFERENCES dramas(id) ON DELETE CASCADE,
      author TEXT NOT NULL, stars INTEGER NOT NULL CHECK (stars BETWEEN 1 AND 5),
      content TEXT NOT NULL, spoiler INTEGER NOT NULL DEFAULT 0, mine INTEGER NOT NULL DEFAULT 0,
      createdAt TEXT NOT NULL
    )''');
    await db.execute('''CREATE TABLE favorites (
      dramaId TEXT PRIMARY KEY REFERENCES dramas(id) ON DELETE CASCADE,
      addedAt TEXT NOT NULL
    )''');
    await db.execute('''CREATE TABLE watch_progress (
      dramaId TEXT PRIMARY KEY REFERENCES dramas(id) ON DELETE CASCADE,
      episodesWatched INTEGER NOT NULL CHECK (episodesWatched >= 0), updatedAt TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'watching'
    )''');
  }

  Future<void> _seedCatalog(Database db) async {
    await db.transaction((txn) async {
      for (final genre in CatalogData.dramas.map((d) => d.genre).toSet()) {
        await txn.insert('genres', {'id': _slug(genre), 'name': genre},
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      for (final drama in CatalogData.dramas) {
        await txn.insert('dramas', drama.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      for (final review in CatalogData.sampleReviews) {
        await txn.insert('reviews', review.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    });
  }

  String _slug(String text) =>
      text.codeUnits.map((unit) => unit.toRadixString(16)).join('-');

  Future<List<Drama>> allDramas(
      {String? country, String? genre, String sort = 'title'}) async {
    final order = switch (sort) {
      'year' => 'year DESC, title COLLATE NOCASE ASC',
      'score' => 'score DESC, title COLLATE NOCASE ASC',
      _ => 'title COLLATE NOCASE ASC',
    };
    final where = <String>[];
    final args = <Object?>[];
    if (country != null && country != 'Все') {
      where.add('country = ?');
      args.add(country);
    }
    if (genre != null && genre != 'Все') {
      where.add('genre = ?');
      args.add(genre);
    }
    final rows = await (await _db).query('dramas',
        where: where.isEmpty ? null : where.join(' AND '),
        whereArgs: args,
        orderBy: order);
    return rows.map(Drama.fromMap).toList();
  }

  Future<List<Drama>> search(String query) async {
    final term = query.trim().toLowerCase();
    final rows = await (await _db).query('dramas');
    return rows
        .map(Drama.fromMap)
        .where((drama) =>
            drama.localizedTitle('kk').toLowerCase().contains(term) ||
            drama.localizedTitle('ru').toLowerCase().contains(term) ||
            drama.localizedTitle('en').toLowerCase().contains(term) ||
            drama.originalTitle.toLowerCase().contains(term) ||
            drama.country.toLowerCase().contains(term) ||
            drama.genre.toLowerCase().contains(term) ||
            drama.year.toString().contains(term))
        .toList();
  }

  Future<Drama?> dramaById(String id) async {
    final rows = await (await _db)
        .query('dramas', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Drama.fromMap(rows.first);
  }

  Future<void> saveDrama(Drama drama) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert(
          'genres', {'id': _slug(drama.genre), 'name': drama.genre},
          conflictAlgorithm: ConflictAlgorithm.ignore);
      final changed = await txn.update('dramas', drama.toMap(),
          where: 'id = ?', whereArgs: [drama.id]);
      if (changed == 0) await txn.insert('dramas', drama.toMap());
    });
  }

  Future<void> deleteDrama(String id) async =>
      (await _db).delete('dramas', where: 'id = ?', whereArgs: [id]);

  Future<List<String>> genres() async => (await _db)
      .query('genres', orderBy: 'name COLLATE NOCASE')
      .then((rows) => rows.map((r) => Genre.fromMap(r).name).toList());

  Future<List<DramaReview>> reviewsFor(String dramaId) async {
    final rows = await (await _db).query('reviews',
        where: 'dramaId = ?', whereArgs: [dramaId], orderBy: 'createdAt DESC');
    return rows.map(DramaReview.fromMap).toList();
  }

  Future<List<DramaReview>> ownReviews() async {
    final rows = await (await _db)
        .query('reviews', where: 'mine = 1', orderBy: 'createdAt DESC');
    return rows.map(DramaReview.fromMap).toList();
  }

  Future<void> saveReview(DramaReview review) async =>
      (await _db).insert('reviews', review.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  Future<void> deleteReview(String id) async => (await _db)
      .delete('reviews', where: 'id = ? AND mine = 1', whereArgs: [id]);

  Future<List<Favorite>> favorites() async {
    final rows = await (await _db).query('favorites', orderBy: 'addedAt DESC');
    return rows.map(Favorite.fromMap).toList();
  }

  Future<void> setFavorite(String id, bool value) async {
    final db = await _db;
    if (value) {
      await db.insert('favorites',
          {'dramaId': id, 'addedAt': DateTime.now().toIso8601String()},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } else {
      await db.delete('favorites', where: 'dramaId = ?', whereArgs: [id]);
    }
  }

  Future<WatchProgress?> progressFor(String id) async {
    final rows = await (await _db).query('watch_progress',
        where: 'dramaId = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : WatchProgress.fromMap(rows.first);
  }

  Future<List<WatchProgress>> allProgress() async =>
      (await (await _db).query('watch_progress', orderBy: 'updatedAt DESC'))
          .map(WatchProgress.fromMap).toList();

  Future<void> setProgress(WatchProgress progress) async {
    final db = await _db;
    final rows = await db.query('dramas',
        columns: ['episodes'],
        where: 'id = ?',
        whereArgs: [progress.dramaId],
        limit: 1);
    if (rows.isEmpty) throw ArgumentError('Дорама не найдена.');
    final total = rows.first['episodes']! as int;
    if (progress.episodesWatched < 0 || progress.episodesWatched > total) {
      throw ArgumentError('Число серий должно быть от 0 до $total.');
    }
    if (progress.episodesWatched == 0 && progress.status == WatchStatus.watching) {
      await db.delete('watch_progress',
          where: 'dramaId = ?', whereArgs: [progress.dramaId]);
    } else {
      await db.insert('watch_progress', progress.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> importLegacy(
      {required List<String> favorites,
      required List<DramaReview> reviews}) async {
    final db = await _db;
    await db.transaction((txn) async {
      for (final id in favorites) {
        if (CatalogData.dramas.any((d) => d.id == id)) {
          await txn.insert('favorites',
              {'dramaId': id, 'addedAt': DateTime.now().toIso8601String()},
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
      for (final review in reviews) {
        await txn.insert('reviews', review.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    });
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
