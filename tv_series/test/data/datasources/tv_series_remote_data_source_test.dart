import 'dart:convert';

import 'package:tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:tv_series/data/models/season_detail_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../json_reader.dart';
import '../../helpers/mocks.dart';

void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_on_the_air.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseApiUrl/tv/on_the_air?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_on_the_air.json'),
            200,
          ),
        );
        final result = await dataSource.getOnTheAirTvSeries();
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseApiUrl/tv/on_the_air?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        final call = dataSource.getOnTheAirTvSeries();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_popular.json')),
    ).tvSeriesList;

    test(
      'should return list of tv series when response is success (200)',
      () async {
        when(
          () => mockHttpClient.get(Uri.parse('$baseApiUrl/tv/popular?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_popular.json'), 200),
        );
        final result = await dataSource.getPopularTvSeries();
        expect(result, tTvSeriesList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          () => mockHttpClient.get(Uri.parse('$baseApiUrl/tv/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        final call = dataSource.getPopularTvSeries();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_top_rated.json')),
    ).tvSeriesList;

    test(
      'should return list of tv series when response code is 200 ',
      () async {
        when(
          () =>
              mockHttpClient.get(Uri.parse('$baseApiUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_top_rated.json'),
            200,
          ),
        );
        final result = await dataSource.getTopRatedTvSeries();
        expect(result, tTvSeriesList);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        when(
          () =>
              mockHttpClient.get(Uri.parse('$baseApiUrl/tv/top_rated?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        final call = dataSource.getTopRatedTvSeries();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv series detail', () {
    const tId = 1;
    final tTvSeriesDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );

    test(
      'should return tv series detail when the response code is 200',
      () async {
        when(
          () => mockHttpClient.get(Uri.parse('$baseApiUrl/tv/$tId?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
        );
        final result = await dataSource.getTvSeriesDetail(tId);
        expect(result, equals(tTvSeriesDetail));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        when(
          () => mockHttpClient.get(Uri.parse('$baseApiUrl/tv/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        final call = dataSource.getTvSeriesDetail(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv series recommendations', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_recommendations.json')),
    ).tvSeriesList;
    const tId = 1;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseApiUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_recommendations.json'),
            200,
          ),
        );
        final result = await dataSource.getTvSeriesRecommendations(tId);
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseApiUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        final call = dataSource.getTvSeriesRecommendations(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_search.json')),
    ).tvSeriesList;
    const tQuery = 'Breaking Bad';

    test('should return list of tv series when response code is 200', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('$baseApiUrl/search/tv?$apiKey&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_series_search.json'), 200),
      );
      final result = await dataSource.searchTvSeries(tQuery);
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseApiUrl/search/tv?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        final call = dataSource.searchTvSeries(tQuery);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get season details', () {
    const tTvId = 1396;
    const tSeasonNumber = 1;
    final tUri = Uri.parse(
      '$baseApiUrl/tv/$tTvId/season/$tSeasonNumber?$apiKey',
    );
    final tSeasonDetail = SeasonDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_season_detail.json')),
    );

    test('should return season detail when response code is 200', () async {
      when(() => mockHttpClient.get(tUri)).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_season_detail.json'),
          200,
        ),
      );

      final result = await dataSource.getSeasonDetails(tTvId, tSeasonNumber);

      expect(result, tSeasonDetail);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        when(
          () => mockHttpClient.get(tUri),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getSeasonDetails(tTvId, tSeasonNumber);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
