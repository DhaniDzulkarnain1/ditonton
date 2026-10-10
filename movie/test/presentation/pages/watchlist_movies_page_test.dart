import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/widgets/movie_card.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockWatchlistMoviesBloc bloc;

  setUp(() {
    bloc = MockWatchlistMoviesBloc();
  });

  Future<void> pumpPage(WidgetTester tester, MovieListState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpApp(
      const WatchlistMoviesPage(),
      providers: [BlocProvider<WatchlistMoviesBloc>.value(value: bloc)],
    );
  }

  testWidgets('should fetch data when the page is opened', (tester) async {
    await pumpPage(tester, const MovieListEmpty());

    verify(() => bloc.add(const FetchWatchlistMovies())).called(1);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byType(MovieCard), findsNothing);
  });

  testWidgets('should display progress bar when loading', (tester) async {
    await pumpPage(tester, const MovieListLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display list of movies when data is loaded', (
    tester,
  ) async {
    await pumpPage(tester, MovieListHasData(testMovieList));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should display message when error', (tester) async {
    await pumpPage(tester, const MovieListError('Error message'));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should refetch watchlist when returning from another page', (
    tester,
  ) async {
    await pumpPage(tester, MovieListHasData(testMovieList));

    await tester.tap(find.byType(MovieCard));
    await tester.pumpAndSettle();
    expect(
      find.text(routeLabel(movieDetailRoute, testMovie.id)),
      findsOneWidget,
    );

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpTransition();

    verify(() => bloc.add(const FetchWatchlistMovies())).called(2);
  });
}
