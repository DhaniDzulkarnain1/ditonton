import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const table = DatabaseHelper.movieWatchlistTable;

  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert succeeds', () async {
      when(
        () =>
            mockDatabaseHelper.insertWatchlist(table, testMovieTable.toJson()),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testMovieTable);

      expect(result, watchlistAddSuccessMessage);
    });

    test('should throw DatabaseException when insert fails', () async {
      when(
        () =>
            mockDatabaseHelper.insertWatchlist(table, testMovieTable.toJson()),
      ).thenThrow(Exception());

      final call = dataSource.insertWatchlist(testMovieTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove succeeds', () async {
      when(
        () => mockDatabaseHelper.removeWatchlist(table, testMovieTable.id),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testMovieTable);

      expect(result, watchlistRemoveSuccessMessage);
    });

    test('should throw DatabaseException when remove fails', () async {
      when(
        () => mockDatabaseHelper.removeWatchlist(table, testMovieTable.id),
      ).thenThrow(Exception());

      final call = dataSource.removeWatchlist(testMovieTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get detail by id', () {
    const tId = 1;

    test('should return the stored item when data is found', () async {
      when(
        () => mockDatabaseHelper.getWatchlistById(table, tId),
      ).thenAnswer((_) async => testMovieMap);

      final result = await dataSource.getMovieById(tId);

      expect(result, testMovieTable);
    });

    test('should return null when data is not found', () async {
      when(
        () => mockDatabaseHelper.getWatchlistById(table, tId),
      ).thenAnswer((_) async => null);

      final result = await dataSource.getMovieById(tId);

      expect(result, null);
    });
  });

  group('get watchlist', () {
    test('should return the stored list from database', () async {
      when(
        () => mockDatabaseHelper.getWatchlist(table),
      ).thenAnswer((_) async => [testMovieMap]);

      final result = await dataSource.getWatchlistMovies();

      expect(result, [testMovieTable]);
    });
  });
}
