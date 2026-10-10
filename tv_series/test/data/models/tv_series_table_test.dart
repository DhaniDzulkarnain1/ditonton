import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';

void main() {
  const tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('fromEntity', () {
    test('should return a valid table from TvSeriesDetail entity', () {
      final result = TvSeriesTable.fromEntity(testTvSeriesDetail);

      expect(result, tTvSeriesTable);
    });
  });

  group('fromMap', () {
    test('should return a valid table from map', () {
      final Map<String, dynamic> map = {
        'id': 1,
        'name': 'name',
        'posterPath': 'posterPath',
        'overview': 'overview',
      };

      final result = TvSeriesTable.fromMap(map);

      expect(result, tTvSeriesTable);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tTvSeriesTable.toJson();

      final expectedMap = {
        'id': 1,
        'name': 'name',
        'posterPath': 'posterPath',
        'overview': 'overview',
      };
      expect(result, expectedMap);
    });
  });

  group('toEntity', () {
    test('should return a watchlist TvSeries entity', () {
      final result = tTvSeriesTable.toEntity();

      const expectedTvSeries = TvSeries.watchlist(
        id: 1,
        name: 'name',
        posterPath: 'posterPath',
        overview: 'overview',
      );
      expect(result, expectedTvSeries);
    });
  });
}
