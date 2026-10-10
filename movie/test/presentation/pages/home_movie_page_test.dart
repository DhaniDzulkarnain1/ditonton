import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/widgets/movie_poster_list.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockNowPlayingMoviesBloc nowPlayingBloc;
  late MockPopularMoviesBloc popularBloc;
  late MockTopRatedMoviesBloc topRatedBloc;

  setUp(() {
    nowPlayingBloc = MockNowPlayingMoviesBloc();
    popularBloc = MockPopularMoviesBloc();
    topRatedBloc = MockTopRatedMoviesBloc();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    MovieListState nowPlaying = const MovieListEmpty(),
    MovieListState popular = const MovieListEmpty(),
    MovieListState topRated = const MovieListEmpty(),
  }) {
    when(() => nowPlayingBloc.state).thenReturn(nowPlaying);
    when(() => popularBloc.state).thenReturn(popular);
    when(() => topRatedBloc.state).thenReturn(topRated);
    return tester.pumpApp(
      const HomeMoviePage(),
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(value: nowPlayingBloc),
        BlocProvider<PopularMoviesBloc>.value(value: popularBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: topRatedBloc),
      ],
    );
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  testWidgets('should fetch all movie lists when the page is opened', (
    tester,
  ) async {
    await pumpPage(tester);

    verify(() => nowPlayingBloc.add(const FetchNowPlayingMovies())).called(1);
    verify(() => popularBloc.add(const FetchPopularMovies())).called(1);
    verify(() => topRatedBloc.add(const FetchTopRatedMovies())).called(1);
    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('should display progress bars when loading', (tester) async {
    await pumpPage(
      tester,
      nowPlaying: const MovieListLoading(),
      popular: const MovieListLoading(),
      topRated: const MovieListLoading(),
    );

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display poster lists when data is loaded', (
    tester,
  ) async {
    await pumpPage(
      tester,
      nowPlaying: MovieListHasData(testMovieList),
      popular: MovieListHasData(testMovieList),
      topRated: MovieListHasData(testMovieList),
    );

    expect(find.byType(MoviePosterList), findsNWidgets(3));
  });

  testWidgets('should display failed text when error', (tester) async {
    await pumpPage(
      tester,
      nowPlaying: const MovieListError('Error'),
      popular: const MovieListError('Error'),
      topRated: const MovieListError('Error'),
    );

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('should open movie detail when a poster is tapped', (
    tester,
  ) async {
    await pumpPage(tester, nowPlaying: MovieListHasData(testMovieList));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(
      find.text(routeLabel(movieDetailRoute, testMovie.id)),
      findsOneWidget,
    );
  });

  testWidgets('should open search page when search icon is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(searchMoviesRoute)), findsOneWidget);
  });

  testWidgets('should open popular page when its see more is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(popularMoviesRoute)), findsOneWidget);
  });

  testWidgets('should open top rated page when its see more is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('See More').last);
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(topRatedMoviesRoute)), findsOneWidget);
  });

  testWidgets('should close the drawer when Movies is tapped', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsNothing);
    expect(find.byType(HomeMoviePage), findsOneWidget);
  });

  testWidgets('should open TV series home from the drawer', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(homeTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should open watchlist from the drawer', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('Watchlist'));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(watchlistMoviesRoute)), findsOneWidget);
  });

  testWidgets('should open about page from the drawer', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(aboutRoute)), findsOneWidget);
  });
}
