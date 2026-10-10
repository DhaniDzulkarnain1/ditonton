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
  late MockTopRatedTvSeriesBloc bloc;

  setUp(() {
    bloc = MockTopRatedTvSeriesBloc();
  });

  Future<void> pumpPage(WidgetTester tester, TvSeriesListState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpApp(
      const TopRatedTvSeriesPage(),
      providers: [BlocProvider<TopRatedTvSeriesBloc>.value(value: bloc)],
    );
  }

  testWidgets('should fetch data when the page is opened', (tester) async {
    await pumpPage(tester, const TvSeriesListEmpty());

    verify(() => bloc.add(const FetchTopRatedTvSeries())).called(1);
    expect(find.text('Top Rated TV Series'), findsOneWidget);
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
}
