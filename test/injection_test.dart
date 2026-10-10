import 'package:core/core.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

import 'helpers/fake_tmdb_client.dart';

void main() {
  late http.Client httpClient;

  setUp(() {
    httpClient = createFakeTmdbClient();
    di.init(httpClient: httpClient);
  });

  tearDown(() => di.locator.reset());

  test('should register the injected http client', () {
    expect(di.locator<http.Client>(), same(httpClient));
    expect(di.locator<DatabaseHelper>(), isA<DatabaseHelper>());
  });

  test('should resolve every movie bloc', () {
    expect(di.locator<NowPlayingMoviesBloc>(), isA<NowPlayingMoviesBloc>());
    expect(di.locator<PopularMoviesBloc>(), isA<PopularMoviesBloc>());
    expect(di.locator<TopRatedMoviesBloc>(), isA<TopRatedMoviesBloc>());
    expect(di.locator<MovieDetailBloc>(), isA<MovieDetailBloc>());
    expect(di.locator<MovieSearchBloc>(), isA<MovieSearchBloc>());
    expect(di.locator<WatchlistMoviesBloc>(), isA<WatchlistMoviesBloc>());
  });

  test('should resolve every TV series bloc', () {
    expect(di.locator<OnTheAirTvSeriesBloc>(), isA<OnTheAirTvSeriesBloc>());
    expect(di.locator<PopularTvSeriesBloc>(), isA<PopularTvSeriesBloc>());
    expect(di.locator<TopRatedTvSeriesBloc>(), isA<TopRatedTvSeriesBloc>());
    expect(di.locator<TvSeriesDetailBloc>(), isA<TvSeriesDetailBloc>());
    expect(di.locator<SeasonEpisodesBloc>(), isA<SeasonEpisodesBloc>());
    expect(di.locator<TvSeriesSearchBloc>(), isA<TvSeriesSearchBloc>());
    expect(di.locator<WatchlistTvSeriesBloc>(), isA<WatchlistTvSeriesBloc>());
  });

  test('should create a new bloc on every request', () {
    expect(
      di.locator<MovieDetailBloc>(),
      isNot(same(di.locator<MovieDetailBloc>())),
    );
  });

  test('should share repositories as singletons', () {
    expect(di.locator<MovieRepository>(), same(di.locator<MovieRepository>()));
    expect(
      di.locator<TvSeriesRepository>(),
      same(di.locator<TvSeriesRepository>()),
    );
  });
}
