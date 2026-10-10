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
  late MockTopRatedMoviesBloc bloc;

  setUp(() {
    bloc = MockTopRatedMoviesBloc();
  });

  Future<void> pumpPage(WidgetTester tester, MovieListState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpApp(
      const TopRatedMoviesPage(),
      providers: [BlocProvider<TopRatedMoviesBloc>.value(value: bloc)],
    );
  }

  testWidgets('should fetch data when the page is opened', (tester) async {
    await pumpPage(tester, const MovieListEmpty());

    verify(() => bloc.add(const FetchTopRatedMovies())).called(1);
    expect(find.text('Top Rated Movies'), findsOneWidget);
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
}
