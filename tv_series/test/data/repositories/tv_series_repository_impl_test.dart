import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_series/data/models/season_detail_model.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTvSeriesModel = TvSeriesModel(
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

  const tTvSeries = TvSeries(
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

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('On The Air TV Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        final result = await repository.getOnTheAirTvSeries();
        verify(() => mockRemoteDataSource.getOnTheAirTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenThrow(ServerException());
        final result = await repository.getOnTheAirTvSeries();
        verify(() => mockRemoteDataSource.getOnTheAirTvSeries());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        when(
          () => mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getOnTheAirTvSeries();
        verify(() => mockRemoteDataSource.getOnTheAirTvSeries());
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Popular TV Series', () {
    test(
      'should return tv series list when call to data source is success',
      () async {
        when(
          () => mockRemoteDataSource.getPopularTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        final result = await repository.getPopularTvSeries();
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(ServerException());
        final result = await repository.getPopularTvSeries();
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        when(
          () => mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getPopularTvSeries();
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TV Series', () {
    test(
      'should return tv series list when call to data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        final result = await repository.getTopRatedTvSeries();
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(ServerException());
        final result = await repository.getTopRatedTvSeries();
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        when(
          () => mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getTopRatedTvSeries();
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Series Detail', () {
    const tId = 1;
    const tTvSeriesResponse = TvSeriesDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Drama')],
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
        SeasonModel(
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

    test(
      'should return TV Series data when the call to remote data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenAnswer((_) async => tTvSeriesResponse);
        final result = await repository.getTvSeriesDetail(tId);
        verify(() => mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(const Right(testTvSeriesDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(ServerException());
        final result = await repository.getTvSeriesDetail(tId);
        verify(() => mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        when(
          () => mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getTvSeriesDetail(tId);
        verify(() => mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Get TV Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    const tId = 1;

    test(
      'should return data (tv series list) when the call is successful',
      () async {
        when(
          () => mockRemoteDataSource.getTvSeriesRecommendations(tId),
        ).thenAnswer((_) async => tTvSeriesList);
        final result = await repository.getTvSeriesRecommendations(tId);
        verify(() => mockRemoteDataSource.getTvSeriesRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvSeriesList));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getTvSeriesRecommendations(tId),
        ).thenThrow(ServerException());
        final result = await repository.getTvSeriesRecommendations(tId);
        verify(() => mockRemoteDataSource.getTvSeriesRecommendations(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        when(
          () => mockRemoteDataSource.getTvSeriesRecommendations(tId),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getTvSeriesRecommendations(tId);
        verify(() => mockRemoteDataSource.getTvSeriesRecommendations(tId));
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Search TV Series', () {
    const tQuery = 'breaking bad';

    test(
      'should return tv series list when call to data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenAnswer((_) async => tTvSeriesModelList);
        final result = await repository.searchTvSeries(tQuery);
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(ServerException());
        final result = await repository.searchTvSeries(tQuery);
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        when(
          () => mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.searchTvSeries(tQuery);
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(
        () => mockLocalDataSource.insertWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(
        () => mockLocalDataSource.insertWatchlist(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(
        () => mockLocalDataSource.removeWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(
        () => mockLocalDataSource.removeWatchlist(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      const tId = 1;
      when(
        () => mockLocalDataSource.getTvSeriesById(tId),
      ).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TV Series', () async {
      when(
        () => mockLocalDataSource.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesTable]);
      final result = await repository.getWatchlistTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });

  group('get season details', () {
    const tTvId = 1396;
    const tSeasonNumber = 1;
    const tSeasonDetail = SeasonDetailResponse(
      id: 'season-id',
      airDate: '2008-01-20',
      episodes: [testEpisodeModel],
      name: 'Season 1',
      overview: 'overview',
      seasonNumber: tSeasonNumber,
    );

    test(
      'should return episodes when call to data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getSeasonDetails(tTvId, tSeasonNumber),
        ).thenAnswer((_) async => tSeasonDetail);

        final result = await repository.getSeasonDetails(tTvId, tSeasonNumber);

        expect(result.getOrElse(() => []), testEpisodeList);
      },
    );

    test(
      'should return ServerFailure when call to data source fails',
      () async {
        when(
          () => mockRemoteDataSource.getSeasonDetails(tTvId, tSeasonNumber),
        ).thenThrow(ServerException());

        final result = await repository.getSeasonDetails(tTvId, tSeasonNumber);

        expect(result, const Left(ServerFailure('')));
      },
    );

    test('should return ConnectionFailure when device is offline', () async {
      when(
        () => mockRemoteDataSource.getSeasonDetails(tTvId, tSeasonNumber),
      ).thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getSeasonDetails(tTvId, tSeasonNumber);

      expect(
        result,
        const Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });
}
