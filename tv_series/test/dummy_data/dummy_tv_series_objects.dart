import 'package:tv_series/data/models/episode_model.dart';
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:core/core.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

const testTvSeries = TvSeries(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [18, 80],
  id: 1396,
  originalName: 'Breaking Bad',
  overview:
      'When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family\'s financial future at any cost as he enters the dangerous world of drugs and crime.',
  popularity: 321.431,
  posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
  firstAirDate: '2008-01-20',
  name: 'Breaking Bad',
  voteAverage: 8.9,
  voteCount: 12500,
);

final testTvSeriesList = [testTvSeries];

const testTvSeriesDetail = TvSeriesDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1.0,
  voteCount: 1,
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  seasons: [
    Season(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
    ),
  ],
);

const testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

const testEpisode = Episode(
  airDate: '2008-01-20',
  episodeNumber: 1,
  id: 62085,
  name: 'Pilot',
  overview: 'A high school chemistry teacher is diagnosed with cancer.',
  stillPath: '/ydlY3iPfeOAvu8gVqrxPoMvzNCn.jpg',
  voteAverage: 8.2,
);

const testEpisodeList = [testEpisode];

const testEpisodeModel = EpisodeModel(
  airDate: '2008-01-20',
  episodeNumber: 1,
  id: 62085,
  name: 'Pilot',
  overview: 'A high school chemistry teacher is diagnosed with cancer.',
  stillPath: '/ydlY3iPfeOAvu8gVqrxPoMvzNCn.jpg',
  voteAverage: 8.2,
);
