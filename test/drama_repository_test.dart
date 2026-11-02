import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/data/models/review.dart';
import 'package:dorama_nest/data/models/watch_progress.dart';
import 'package:dorama_nest/data/services/drama_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late DramaRepository repository;

  setUp(() async {
    sqfliteFfiInit();
    directory = await Directory.systemTemp.createTemp('dorama-nest-');
    repository = DramaRepository(
      factory: databaseFactoryFfi,
      databasePath: '${directory.path}/test.db',
    );
  });

  tearDown(() async {
    await repository.close();
    await directory.delete(recursive: true);
  });

  test('stores seeded data and returns filtered, sorted and searched rows',
      () async {
    final catalog = await repository.allDramas();
    expect(catalog.length, 37);
    expect((await repository.allDramas(country: 'Корея')).length, 34);
    expect((await repository.allDramas(genre: 'Романтика')).length, 11);
    expect(catalog.where((drama) => drama.posterUrl != null).length, 30);
    final addedDrama = catalog.singleWhere((drama) => drama.title == 'My Demon');
    expect(addedDrama.localizedTitle('kk'), 'Менің жын-перім');
    expect(addedDrama.localizedDescription('ru'), contains('наследницей'));
    expect((await repository.search('Queen')).single.id, 'queen-tears');
    final sorted = await repository.allDramas(sort: 'score');
    expect(sorted.first.id, 'goblin');
  });

  test('creates, reads, updates and deletes a drama with related rows',
      () async {
    final drama = _customDrama();
    await repository.saveDrama(drama);
    expect((await repository.dramaById(drama.id))?.title, drama.title);
    await repository.setFavorite(drama.id, true);
    await repository.setProgress(WatchProgress(
        dramaId: drama.id, episodesWatched: 2, updatedAt: DateTime.now()));
    await repository.saveReview(_review(drama.id));

    await repository.saveDrama(Drama(
      id: drama.id,
      title: 'Edited Drama',
      originalTitle: drama.originalTitle,
      country: drama.country,
      year: drama.year,
      genre: 'Драма',
      episodes: drama.episodes,
      score: drama.score,
      description: drama.description,
      symbol: drama.symbol,
      start: drama.start,
      end: drama.end,
      isCustom: true,
    ));
    expect((await repository.dramaById(drama.id))?.genre, 'Драма');
    expect((await repository.favorites()).single.dramaId, drama.id);
    expect((await repository.reviewsFor(drama.id)).single.id, 'test-review');
    expect((await repository.progressFor(drama.id))?.episodesWatched, 2);
    await repository.deleteDrama(drama.id);
    expect(await repository.dramaById(drama.id), isNull);
    expect(await repository.favorites(), isEmpty);
    expect(await repository.reviewsFor(drama.id), isEmpty);
  });

  test('keeps favorites and reviews after reopening the database', () async {
    await repository.setFavorite('hidden-love', true);
    await repository.saveReview(_review('hidden-love'));
    await repository.close();
    repository = DramaRepository(
        factory: databaseFactoryFfi, databasePath: '${directory.path}/test.db');
    expect((await repository.favorites()).single.dramaId, 'hidden-love');
    expect((await repository.ownReviews()).single.content,
        'A lovely local review.');
  });

  test('updates and deletes a personal review', () async {
    final review = _review('hidden-love');
    await repository.saveReview(review);
    await repository.saveReview(
        review.copyWith(stars: 5, content: 'An updated local review.'));
    expect(
        (await repository.reviewsFor('hidden-love'))
            .where((r) => r.id == review.id)
            .single
            .content,
        'An updated local review.');
    await repository.deleteReview(review.id);
    expect(
        (await repository.reviewsFor('hidden-love'))
            .any((r) => r.id == review.id),
        isFalse);
  });

  test('rejects invalid foreign keys and invalid episode progress', () async {
    await expectLater(
        repository.setFavorite('unknown', true), throwsA(anything));
    await expectLater(
        repository.setProgress(WatchProgress(
            dramaId: 'hidden-love',
            episodesWatched: 26,
            updatedAt: DateTime.now())),
        throwsArgumentError);
  });
}

Drama _customDrama() => const Drama(
      id: 'custom-drama',
      title: 'My Drama',
      originalTitle: '我的剧',
      country: 'Китай',
      year: 2025,
      genre: 'Романтика',
      episodes: 12,
      score: 0,
      description: 'A user created drama for repository tests.',
      symbol: '✿',
      start: Color(0xFFEDAAB1),
      end: Color(0xFF925A8A),
      isCustom: true,
    );

DramaReview _review(String dramaId) => DramaReview(
      id: 'test-review',
      dramaId: dramaId,
      author: 'Test',
      stars: 4,
      content: 'A lovely local review.',
      spoiler: false,
      mine: true,
      createdAt: DateTime.utc(2026, 1, 1),
    );
