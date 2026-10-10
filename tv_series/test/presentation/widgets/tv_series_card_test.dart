import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, TvSeries tvSeries) {
    return tester.pumpApp(
      Scaffold(body: TvSeriesCard(tvSeries)),
      providers: [
        BlocProvider<PopularTvSeriesBloc>.value(
          value: MockPopularTvSeriesBloc(),
        ),
      ],
    );
  }

  testWidgets('should display name and overview', (tester) async {
    await pumpCard(tester, testTvSeries);

    expect(find.text(testTvSeries.name!), findsOneWidget);
    expect(find.text(testTvSeries.overview!), findsOneWidget);
  });

  testWidgets('should display placeholders when name and overview are null', (
    tester,
  ) async {
    const tvSeries = TvSeries.watchlist(
      id: 1,
      overview: null,
      posterPath: 'posterPath',
      name: null,
    );

    await pumpCard(tester, tvSeries);

    expect(find.text('-'), findsNWidgets(2));
  });

  testWidgets('should open TV series detail when tapped', (tester) async {
    await pumpCard(tester, testTvSeries);

    await tester.tap(find.byType(TvSeriesCard));
    await tester.pumpAndSettle();

    expect(
      find.text(routeLabel(tvSeriesDetailRoute, testTvSeries.id)),
      findsOneWidget,
    );
  });
}
