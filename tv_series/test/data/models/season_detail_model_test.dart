import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/data/models/season_detail_model.dart';
import 'package:tv_series/domain/entities/episode.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../json_reader.dart';

void main() {
  final Map<String, dynamic> tJson = json.decode(
    readJson('dummy_data/tv_series_season_detail.json'),
  );
  final tModel = SeasonDetailResponse.fromJson(tJson);

  group('SeasonDetailResponse', () {
    test('fromJson should return a valid model from JSON', () {
      expect(tModel.id, '5256c89f19c2956ff6046d47');
      expect(tModel.name, 'Season 1');
      expect(tModel.seasonNumber, 1);
      expect(tModel.episodes.length, 2);
      expect(tModel.episodes.first, testEpisodeModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tModel.toJson();

      expect(SeasonDetailResponse.fromJson(result), tModel);
      expect(result['_id'], tJson['_id']);
      expect(result['season_number'], tJson['season_number']);
    });
  });

  group('EpisodeModel', () {
    test('fromJson should convert integer rating to double', () {
      expect(tModel.episodes.last.voteAverage, 8.0);
      expect(tModel.episodes.last.stillPath, isNull);
    });

    test('toJson should return a JSON map containing proper data', () {
      expect(testEpisodeModel.toJson(), tJson['episodes'][0]);
    });

    test('toEntity should return an Episode entity', () {
      final result = testEpisodeModel.toEntity();

      expect(result, isA<Episode>());
      expect(result, testEpisode);
    });
  });
}
