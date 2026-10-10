import 'dart:io';

import 'package:core/core.dart' hide DatabaseException;
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  const movieTable = DatabaseHelper.movieWatchlistTable;
  const tvSeriesTable = DatabaseHelper.tvSeriesWatchlistTable;
  const tMovie = {
    'id': 1,
    'title': 'title',
    'overview': 'overview',
    'posterPath': 'posterPath',
  };
  const tTvSeries = {
    'id': 1,
    'name': 'name',
    'overview': 'overview',
    'posterPath': 'posterPath',
  };

  late DatabaseHelper databaseHelper;
  late Directory databaseDirectory;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseDirectory = Directory.systemTemp.createTempSync('ditonton_test');
    await databaseFactory.setDatabasesPath(databaseDirectory.path);
    databaseHelper = DatabaseHelper();
  });

  tearDown(() async {
    await databaseHelper.close();
    databaseDirectory.deleteSync(recursive: true);
  });

  test('should always return the same instance', () {
    expect(DatabaseHelper(), same(databaseHelper));
  });

  test('should start with an empty watchlist', () async {
    expect(await databaseHelper.getWatchlist(movieTable), isEmpty);
    expect(await databaseHelper.getWatchlist(tvSeriesTable), isEmpty);
  });

  test('should insert and read a watchlist item', () async {
    await databaseHelper.insertWatchlist(movieTable, tMovie);

    expect(await databaseHelper.getWatchlistById(movieTable, 1), tMovie);
    expect(await databaseHelper.getWatchlist(movieTable), [tMovie]);
  });

  test('should return null when the item is not in the watchlist', () async {
    expect(await databaseHelper.getWatchlistById(movieTable, 1), isNull);
  });

  test('should remove a watchlist item', () async {
    await databaseHelper.insertWatchlist(movieTable, tMovie);

    final removedCount = await databaseHelper.removeWatchlist(movieTable, 1);

    expect(removedCount, 1);
    expect(await databaseHelper.getWatchlist(movieTable), isEmpty);
  });

  test('should keep movie and TV series watchlists separate', () async {
    await databaseHelper.insertWatchlist(tvSeriesTable, tTvSeries);

    expect(await databaseHelper.getWatchlist(tvSeriesTable), [tTvSeries]);
    expect(await databaseHelper.getWatchlist(movieTable), isEmpty);
  });

  test('should fail when the same item is inserted twice', () async {
    await databaseHelper.insertWatchlist(movieTable, tMovie);

    expect(
      () => databaseHelper.insertWatchlist(movieTable, tMovie),
      throwsA(isA<DatabaseException>()),
    );
  });
}
