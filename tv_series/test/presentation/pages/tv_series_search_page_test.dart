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
  late MockTvSeriesSearchBloc bloc;

  setUp(() {
    bloc = MockTvSeriesSearchBloc();
  });

  Future<void> pumpPage(WidgetTester tester, TvSeriesListState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpApp(
      const TvSeriesSearchPage(),
      providers: [BlocProvider<TvSeriesSearchBloc>.value(value: bloc)],
    );
  }

  testWidgets('should show an empty result before searching', (tester) async {
    await pumpPage(tester, const TvSeriesListEmpty());

    expect(find.text('Search Result'), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsNothing);
  });

  testWidgets('should submit the query when search is submitted', (
    tester,
  ) async {
    await pumpPage(tester, const TvSeriesListEmpty());

    await tester.enterText(find.byType(TextField), 'breaking bad');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(
      () => bloc.add(const TvSeriesSearchSubmitted('breaking bad')),
    ).called(1);
  });

  testWidgets('should display progress bar when loading', (tester) async {
    await pumpPage(tester, const TvSeriesListLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display search result when data is loaded', (
    tester,
  ) async {
    await pumpPage(tester, TvSeriesListHasData(testTvSeriesList));

    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should display message when error', (tester) async {
    await pumpPage(tester, const TvSeriesListError('Error message'));

    expect(find.text('Error message'), findsOneWidget);
  });
}
