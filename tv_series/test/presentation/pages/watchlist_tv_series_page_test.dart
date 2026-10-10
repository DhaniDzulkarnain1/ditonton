import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockWatchlistTvSeriesBloc bloc;

  setUp(() {
    bloc = MockWatchlistTvSeriesBloc();
  });

  Future<void> pumpPage(WidgetTester tester, TvSeriesListState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpApp(
      const WatchlistTvSeriesPage(),
      providers: [BlocProvider<WatchlistTvSeriesBloc>.value(value: bloc)],
    );
  }

  testWidgets('should fetch data when the page is opened', (tester) async {
    await pumpPage(tester, const TvSeriesListEmpty());

    verify(() => bloc.add(const FetchWatchlistTvSeries())).called(1);
    expect(find.text('Watchlist TV Series'), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsNothing);
  });

  testWidgets('should display progress bar when loading', (tester) async {
    await pumpPage(tester, const TvSeriesListLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display list of TV series when data is loaded', (
    tester,
  ) async {
    await pumpPage(tester, TvSeriesListHasData(testTvSeriesList));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should display message when error', (tester) async {
    await pumpPage(tester, const TvSeriesListError('Error message'));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should refetch watchlist when returning from another page', (
    tester,
  ) async {
    await pumpPage(tester, TvSeriesListHasData(testTvSeriesList));

    await tester.tap(find.byType(TvSeriesCard));
    await tester.pumpAndSettle();
    expect(
      find.text(routeLabel(tvSeriesDetailRoute, testTvSeries.id)),
      findsOneWidget,
    );

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpTransition();

    verify(() => bloc.add(const FetchWatchlistTvSeries())).called(2);
  });
}
