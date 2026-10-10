import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const table = DatabaseHelper.tvSeriesWatchlistTable;

  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist', () {
    test('should return success message when insert succeeds', () async {
      when(
        () => mockDatabaseHelper.insertWatchlist(
          table,
          testTvSeriesTable.toJson(),
        ),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testTvSeriesTable);

      expect(result, watchlistAddSuccessMessage);
    });

    test('should throw DatabaseException when insert fails', () async {
      when(
        () => mockDatabaseHelper.insertWatchlist(
          table,
          testTvSeriesTable.toJson(),
        ),
      ).thenThrow(Exception());

      final call = dataSource.insertWatchlist(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove succeeds', () async {
      when(
        () => mockDatabaseHelper.removeWatchlist(table, testTvSeriesTable.id),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTvSeriesTable);

      expect(result, watchlistRemoveSuccessMessage);
    });

    test('should throw DatabaseException when remove fails', () async {
      when(
        () => mockDatabaseHelper.removeWatchlist(table, testTvSeriesTable.id),
      ).thenThrow(Exception());

      final call = dataSource.removeWatchlist(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get detail by id', () {
    const tId = 1;

    test('should return the stored item when data is found', () async {
      when(
        () => mockDatabaseHelper.getWatchlistById(table, tId),
      ).thenAnswer((_) async => testTvSeriesMap);

      final result = await dataSource.getTvSeriesById(tId);

      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      when(
        () => mockDatabaseHelper.getWatchlistById(table, tId),
      ).thenAnswer((_) async => null);

      final result = await dataSource.getTvSeriesById(tId);

      expect(result, null);
    });
  });

  group('get watchlist', () {
    test('should return the stored list from database', () async {
      when(
        () => mockDatabaseHelper.getWatchlist(table),
      ).thenAnswer((_) async => [testTvSeriesMap]);

      final result = await dataSource.getWatchlistTvSeries();

      expect(result, [testTvSeriesTable]);
    });
  });
}
