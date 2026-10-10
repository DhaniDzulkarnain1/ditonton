import 'package:core/core.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvSeriesDetailModel = TvSeriesDetailResponse(
    backdropPath: '/backdropPath.jpg',
    genres: [GenreModel(id: 1, name: 'Drama')],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    posterPath: '/posterPath.jpg',
    firstAirDate: '2020-05-05',
    name: 'Name',
    voteAverage: 8.5,
    voteCount: 1000,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [
      SeasonModel(
        airDate: '2020-05-05',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'Season overview',
        posterPath: '/seasonPoster.jpg',
        seasonNumber: 1,
      ),
    ],
  );

  const tTvSeriesDetail = TvSeriesDetail(
    backdropPath: '/backdropPath.jpg',
    genres: [Genre(id: 1, name: 'Drama')],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    posterPath: '/posterPath.jpg',
    firstAirDate: '2020-05-05',
    name: 'Name',
    voteAverage: 8.5,
    voteCount: 1000,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [
      Season(
        airDate: '2020-05-05',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'Season overview',
        posterPath: '/seasonPoster.jpg',
        seasonNumber: 1,
      ),
    ],
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = {
        'backdrop_path': '/backdropPath.jpg',
        'genres': [
          {'id': 1, 'name': 'Drama'},
        ],
        'id': 1,
        'original_name': 'Original Name',
        'overview': 'Overview',
        'poster_path': '/posterPath.jpg',
        'first_air_date': '2020-05-05',
        'name': 'Name',
        'vote_average': 8.5,
        'vote_count': 1000,
        'number_of_episodes': 10,
        'number_of_seasons': 1,
        'seasons': [
          {
            'air_date': '2020-05-05',
            'episode_count': 10,
            'id': 1,
            'name': 'Season 1',
            'overview': 'Season overview',
            'poster_path': '/seasonPoster.jpg',
            'season_number': 1,
          },
        ],
      };

      final result = TvSeriesDetailResponse.fromJson(jsonMap);

      expect(result, tTvSeriesDetailModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvSeriesDetailModel.toJson();

      final expectedJsonMap = {
        'backdrop_path': '/backdropPath.jpg',
        'genres': [
          {'id': 1, 'name': 'Drama'},
        ],
        'id': 1,
        'original_name': 'Original Name',
        'overview': 'Overview',
        'poster_path': '/posterPath.jpg',
        'first_air_date': '2020-05-05',
        'name': 'Name',
        'vote_average': 8.5,
        'vote_count': 1000,
        'number_of_episodes': 10,
        'number_of_seasons': 1,
        'seasons': [
          {
            'air_date': '2020-05-05',
            'episode_count': 10,
            'id': 1,
            'name': 'Season 1',
            'overview': 'Season overview',
            'poster_path': '/seasonPoster.jpg',
            'season_number': 1,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should be a subclass of TvSeriesDetail entity', () async {
      final result = tTvSeriesDetailModel.toEntity();
      expect(result, tTvSeriesDetail);
    });
  });
}
