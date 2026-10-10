import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Client createFakeTmdbClient() {
  return MockClient((request) async {
    final fixture = _fixtureFor(request.url.path);
    if (fixture == null) {
      return http.Response('Not Found', 404);
    }
    return http.Response(
      File(fixture).readAsStringSync(),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
}

String? _fixtureFor(String path) {
  const movieFixtures = 'movie/test/dummy_data';
  const tvSeriesFixtures = 'tv_series/test/dummy_data';

  final routes = <RegExp, String>{
    RegExp(r'^/3/movie/now_playing$'): '$movieFixtures/now_playing.json',
    RegExp(r'^/3/movie/popular$'): '$movieFixtures/popular.json',
    RegExp(r'^/3/movie/top_rated$'): '$movieFixtures/top_rated.json',
    RegExp(r'^/3/search/movie$'): '$movieFixtures/search_spiderman_movie.json',
    RegExp(r'^/3/movie/\d+/recommendations$'):
        '$movieFixtures/movie_recommendations.json',
    RegExp(r'^/3/movie/\d+$'): '$movieFixtures/movie_detail.json',
    RegExp(r'^/3/tv/on_the_air$'):
        '$tvSeriesFixtures/tv_series_on_the_air.json',
    RegExp(r'^/3/tv/popular$'): '$tvSeriesFixtures/tv_series_popular.json',
    RegExp(r'^/3/tv/top_rated$'): '$tvSeriesFixtures/tv_series_top_rated.json',
    RegExp(r'^/3/search/tv$'): '$tvSeriesFixtures/tv_series_search.json',
    RegExp(r'^/3/tv/\d+/recommendations$'):
        '$tvSeriesFixtures/tv_series_recommendations.json',
    RegExp(r'^/3/tv/\d+/season/\d+$'):
        '$tvSeriesFixtures/tv_series_season_detail.json',
    RegExp(r'^/3/tv/\d+$'): '$tvSeriesFixtures/tv_series_detail.json',
  };

  for (final route in routes.entries) {
    if (route.key.hasMatch(path)) {
      return route.value;
    }
  }
  return null;
}
