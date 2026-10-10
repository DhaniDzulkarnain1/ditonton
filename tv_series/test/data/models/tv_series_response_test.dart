import 'dart:convert';

import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    backdropPath: '/path.jpg',
    genreIds: [18, 80],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2020-05-05',
    name: 'Name',
    voteAverage: 1.0,
    voteCount: 1,
  );
  const tTvSeriesResponseModel = TvSeriesResponse(
    tvSeriesList: <TvSeriesModel>[tTvSeriesModel],
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series_on_the_air.json'),
      );
      final result = TvSeriesResponse.fromJson(jsonMap);
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvSeriesResponseModel.toJson();
      final expectedJsonMap = {
        'results': [
          {
            'backdrop_path': '/path.jpg',
            'genre_ids': [18, 80],
            'id': 1,
            'original_name': 'Original Name',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': '/path.jpg',
            'first_air_date': '2020-05-05',
            'name': 'Name',
            'vote_average': 1.0,
            'vote_count': 1,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
