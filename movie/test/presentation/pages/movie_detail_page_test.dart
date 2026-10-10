import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  const tLoadedState = MovieDetailState(
    movieState: RequestState.loaded,
    movie: testMovieDetail,
    recommendationState: RequestState.loaded,
  );

  late MockMovieDetailBloc bloc;

  setUp(() {
    bloc = MockMovieDetailBloc();
  });

  Future<void> pumpPage(
    WidgetTester tester,
    MovieDetailState state, {
    List<MovieDetailState> nextStates = const [],
  }) {
    whenListen(bloc, Stream.fromIterable(nextStates), initialState: state);
    return tester.pumpApp(
      MovieDetailPage(id: testMovieDetail.id),
      providers: [BlocProvider<MovieDetailBloc>.value(value: bloc)],
    );
  }

  testWidgets('should fetch movie detail when the page is opened', (
    tester,
  ) async {
    await pumpPage(tester, const MovieDetailState());

    verify(() => bloc.add(FetchMovieDetail(testMovieDetail.id))).called(1);
  });

  testWidgets('should display progress bar when loading', (tester) async {
    await pumpPage(
      tester,
      const MovieDetailState(movieState: RequestState.loading),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display message when error', (tester) async {
    await pumpPage(
      tester,
      const MovieDetailState(
        movieState: RequestState.error,
        message: 'Error message',
      ),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should display movie information when loaded', (tester) async {
    await pumpPage(tester, tLoadedState);

    expect(find.text('title'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('2h 0m'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
  });

  testWidgets('should display minutes only when runtime is under an hour', (
    tester,
  ) async {
    const shortMovie = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 45,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );

    await pumpPage(tester, tLoadedState.copyWith(movie: shortMovie));

    expect(find.text('45m'), findsOneWidget);
  });

  testWidgets('should display add icon when movie is not in watchlist', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState);

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('should display check icon when movie is in watchlist', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState.copyWith(isAddedToWatchlist: true));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should add movie to watchlist when button is tapped', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState);

    await tester.tap(find.byType(FilledButton));

    verify(
      () => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
    ).called(1);
  });

  testWidgets('should remove movie from watchlist when button is tapped', (
    tester,
  ) async {
    await pumpPage(tester, tLoadedState.copyWith(isAddedToWatchlist: true));

    await tester.tap(find.byType(FilledButton));

    verify(
      () => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
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

  testWidgets('should open the recommended movie when it is tapped', (
    tester,
  ) async {
    await pumpPage(
      tester,
      tLoadedState.copyWith(recommendations: testMovieList),
    );

    final recommendation = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(InkWell),
    );
    await tester.ensureVisible(recommendation);
    await tester.pumpTransition();
    await tester.tap(recommendation);
    await tester.pumpAndSettle();

    expect(
      find.text(routeLabel(movieDetailRoute, testMovie.id)),
      findsOneWidget,
    );
  });

  testWidgets('should display a back button', (tester) async {
    await pumpPage(tester, tLoadedState);

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
