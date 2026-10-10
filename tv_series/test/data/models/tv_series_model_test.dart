import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    backdropPath: '/backdropPath.jpg',
    genreIds: [18, 80],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 123.456,
    posterPath: '/posterPath.jpg',
    firstAirDate: '2020-05-05',
    name: 'Name',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  const tTvSeries = TvSeries(
    backdropPath: '/backdropPath.jpg',
    genreIds: [18, 80],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 123.456,
    posterPath: '/posterPath.jpg',
    firstAirDate: '2020-05-05',
    name: 'Name',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = {
        'backdrop_path': '/backdropPath.jpg',
        'genre_ids': [18, 80],
        'id': 1,
        'original_name': 'Original Name',
        'overview': 'Overview',
        'popularity': 123.456,
        'poster_path': '/posterPath.jpg',
        'first_air_date': '2020-05-05',
        'name': 'Name',
        'vote_average': 8.5,
        'vote_count': 1000,
      };

      final result = TvSeriesModel.fromJson(jsonMap);

      expect(result, tTvSeriesModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvSeriesModel.toJson();

      final expectedJsonMap = {
        'backdrop_path': '/backdropPath.jpg',
        'genre_ids': [18, 80],
        'id': 1,
        'original_name': 'Original Name',
        'overview': 'Overview',
        'popularity': 123.456,
        'poster_path': '/posterPath.jpg',
        'first_air_date': '2020-05-05',
        'name': 'Name',
        'vote_average': 8.5,
        'vote_count': 1000,
      };
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should be a subclass of TvSeries entity', () async {
      final result = tTvSeriesModel.toEntity();
      expect(result, tTvSeries);
    });
  });
}
