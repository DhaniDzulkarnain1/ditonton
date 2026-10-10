import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';
import 'package:tv_series/presentation/widgets/tv_series_poster_list.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockOnTheAirTvSeriesBloc onTheAirBloc;
  late MockPopularTvSeriesBloc popularBloc;
  late MockTopRatedTvSeriesBloc topRatedBloc;

  setUp(() {
    onTheAirBloc = MockOnTheAirTvSeriesBloc();
    popularBloc = MockPopularTvSeriesBloc();
    topRatedBloc = MockTopRatedTvSeriesBloc();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    TvSeriesListState onTheAir = const TvSeriesListEmpty(),
    TvSeriesListState popular = const TvSeriesListEmpty(),
    TvSeriesListState topRated = const TvSeriesListEmpty(),
  }) {
    when(() => onTheAirBloc.state).thenReturn(onTheAir);
    when(() => popularBloc.state).thenReturn(popular);
    when(() => topRatedBloc.state).thenReturn(topRated);
    return tester.pumpApp(
      const HomeTvSeriesPage(),
      providers: [
        BlocProvider<OnTheAirTvSeriesBloc>.value(value: onTheAirBloc),
        BlocProvider<PopularTvSeriesBloc>.value(value: popularBloc),
        BlocProvider<TopRatedTvSeriesBloc>.value(value: topRatedBloc),
      ],
    );
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  testWidgets('should fetch all TV series lists when the page is opened', (
    tester,
  ) async {
    await pumpPage(tester);

    verify(() => onTheAirBloc.add(const FetchOnTheAirTvSeries())).called(1);
    verify(() => popularBloc.add(const FetchPopularTvSeries())).called(1);
    verify(() => topRatedBloc.add(const FetchTopRatedTvSeries())).called(1);
    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('should display progress bars when loading', (tester) async {
    await pumpPage(
      tester,
      onTheAir: const TvSeriesListLoading(),
      popular: const TvSeriesListLoading(),
      topRated: const TvSeriesListLoading(),
    );

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display poster lists when data is loaded', (
    tester,
  ) async {
    await pumpPage(
      tester,
      onTheAir: TvSeriesListHasData(testTvSeriesList),
      popular: TvSeriesListHasData(testTvSeriesList),
      topRated: TvSeriesListHasData(testTvSeriesList),
    );

    expect(find.byType(TvSeriesPosterList), findsNWidgets(3));
  });

  testWidgets('should display failed text when error', (tester) async {
    await pumpPage(
      tester,
      onTheAir: const TvSeriesListError('Error'),
      popular: const TvSeriesListError('Error'),
      topRated: const TvSeriesListError('Error'),
    );

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('should open TV series detail when a poster is tapped', (
    tester,
  ) async {
    await pumpPage(tester, onTheAir: TvSeriesListHasData(testTvSeriesList));

    await tester.tap(
      find.descendant(
        of: find.byType(TvSeriesPosterList),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(routeLabel(tvSeriesDetailRoute, testTvSeries.id)),
      findsOneWidget,
    );
  });

  testWidgets('should open search page when search icon is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(searchTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should open popular page when its see more is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('See More').at(1));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(popularTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should open on the air page when its see more is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(onTheAirTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should open top rated page when its see more is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('See More').last);
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(topRatedTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should close the drawer when TV Series is tapped', (
    tester,
  ) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.text('TV Series'), findsNothing);
    expect(find.byType(HomeTvSeriesPage), findsOneWidget);
  });

  testWidgets('should open movie home from the drawer', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(homeMovieRoute)), findsOneWidget);
  });

  testWidgets('should open watchlist from the drawer', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('Watchlist'));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(watchlistTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should open about page from the drawer', (tester) async {
    await pumpPage(tester);
    await openDrawer(tester);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text(routeLabel(aboutRoute)), findsOneWidget);
  });
}
