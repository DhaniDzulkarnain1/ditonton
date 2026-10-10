import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2020-05-05',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/posterPath.jpg',
    seasonNumber: 1,
  );

  const tSeason = Season(
    airDate: '2020-05-05',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/posterPath.jpg',
    seasonNumber: 1,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = {
        'air_date': '2020-05-05',
        'episode_count': 10,
        'id': 1,
        'name': 'Season 1',
        'overview': 'Overview',
        'poster_path': '/posterPath.jpg',
        'season_number': 1,
      };

      final result = SeasonModel.fromJson(jsonMap);

      expect(result, tSeasonModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tSeasonModel.toJson();

      final expectedJsonMap = {
        'air_date': '2020-05-05',
        'episode_count': 10,
        'id': 1,
        'name': 'Season 1',
        'overview': 'Overview',
        'poster_path': '/posterPath.jpg',
        'season_number': 1,
      };
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should be a subclass of Season entity', () async {
      final result = tSeasonModel.toEntity();
      expect(result, tSeason);
    });
  });
}
