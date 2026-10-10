import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  const tLoadedState = TvSeriesDetailState(
    tvSeriesState: RequestState.loaded,
    tvSeries: testTvSeriesDetail,
    recommendationState: RequestState.loaded,
  );

  late MockTvSeriesDetailBloc bloc;
  late MockSeasonEpisodesBloc seasonEpisodesBloc;

  setUp(() {
    bloc = MockTvSeriesDetailBloc();
    seasonEpisodesBloc = MockSeasonEpisodesBloc();
    when(
      () => seasonEpisodesBloc.state,
    ).thenReturn(const SeasonEpisodesState());
  });

  Future<void> pumpPage(
    WidgetTester tester,
    TvSeriesDetailState state, {
    List<TvSeriesDetailState> nextStates = const [],
  }) {
    whenListen(bloc, Stream.fromIterable(nextStates), initialState: state);
    return tester.pumpApp(
      TvSeriesDetailPage(id: testTvSeriesDetail.id),
      providers: [
        BlocProvider<TvSeriesDetailBloc>.value(value: bloc),
        BlocProvider<SeasonEpisodesBloc>.value(value: seasonEpisodesBloc),
      ],
    );
  }

  testWidgets('should fetch TV series detail when the page is opened', (
    tester,
  ) async {
    await pumpPage(tester, const TvSeriesDetailState());

    verify(
      () => bloc.add(FetchTvSeriesDetail(testTvSeriesDetail.id)),
    ).called(1);
  });

  testWidgets('should display progress bar when loading', (tester) async {
    await pumpPage(
      tester,
      const TvSeriesDetailState(tvSeriesState: RequestState.loading),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display message when error', (tester) async {
    await pumpPage(
      tester,
      const TvSeriesDetailState(
        tvSeriesState: RequestState.error,
        message: 'Error message',
      ),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should display TV series information when loaded', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState);

    expect(find.text('name'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('First Air Date: firstAirDate'), findsOneWidget);
    expect(find.text('Seasons (1 seasons, 10 episodes)'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
  });

  testWidgets('should display add icon when TV series is not in watchlist', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState);

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('should display check icon when TV series is in watchlist', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState.copyWith(isAddedToWatchlist: true));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should add TV series to watchlist when button is tapped', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState);

    await tester.tap(find.byType(FilledButton));

    verify(
      () => bloc.add(const AddTvSeriesToWatchlist(testTvSeriesDetail)),
    ).called(1);
  });

  testWidgets('should remove TV series from watchlist when button is tapped', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState.copyWith(isAddedToWatchlist: true));

    await tester.tap(find.byType(FilledButton));

    verify(
      () => bloc.add(const RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
    ).called(1);
  });

  testWidgets('should display snackbar when added to watchlist', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState,
      nextStates: [
        tLoadedState.copyWith(
          watchlistMessage: watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
    );
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets('should display snackbar when removed from watchlist', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState.copyWith(isAddedToWatchlist: true),
      nextStates: [
        tLoadedState.copyWith(watchlistMessage: watchlistRemoveSuccessMessage),
      ],
    );
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(watchlistRemoveSuccessMessage), findsOneWidget);
  });

  testWidgets('should display alert dialog when watchlist action fails', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState,
      nextStates: [tLoadedState.copyWith(watchlistMessage: 'Failed')],
    );
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('should display progress bar when recommendations are loading', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState.copyWith(recommendationState: RequestState.loading),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display message when recommendations fail', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState.copyWith(
        recommendationState: RequestState.error,
        message: 'Recommendation error',
      ),
    );

    expect(find.text('Recommendation error'), findsOneWidget);
  });

  testWidgets('should display nothing when recommendations are empty', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState.copyWith(recommendationState: RequestState.empty),
    );

    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('should open the recommended TV series when it is tapped', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState.copyWith(recommendations: testTvSeriesList),
    );

    final recommendation = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(CachedNetworkImage),
    );
    await tester.ensureVisible(recommendation);
    await tester.pumpTransition();
    await tester.tap(recommendation);
    await tester.pumpAndSettle();

    expect(
      find.text(routeLabel(tvSeriesDetailRoute, testTvSeries.id)),
      findsOneWidget,
    );
  });

  testWidgets('should display a back button', (tester) async {
    await pumpPage(tester, tLoadedState);

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
