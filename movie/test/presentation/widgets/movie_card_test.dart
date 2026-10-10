import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/widgets/movie_card.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, Movie movie) {
    return tester.pumpApp(
      Scaffold(body: MovieCard(movie)),
      providers: [
        BlocProvider<PopularMoviesBloc>.value(value: MockPopularMoviesBloc()),
      ],
    );
  }

  testWidgets('should display title and overview', (tester) async {
    await pumpCard(tester, testMovie);

    expect(find.text(testMovie.title!), findsOneWidget);
    expect(find.text(testMovie.overview!), findsOneWidget);
  });

  testWidgets('should display placeholders when title and overview are null', (
    tester,
  ) async {
    const movie = Movie.watchlist(
      id: 1,
      overview: null,
      posterPath: 'posterPath',
      title: null,
    );

    await pumpCard(tester, movie);

    expect(find.text('-'), findsNWidgets(2));
  });

  testWidgets('should open movie detail when tapped', (tester) async {
    await pumpCard(tester, testMovie);

    await tester.tap(find.byType(MovieCard));
    await tester.pumpAndSettle();

    expect(
      find.text(routeLabel(movieDetailRoute, testMovie.id)),
      findsOneWidget,
    );
  });
}
