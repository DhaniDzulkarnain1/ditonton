import 'package:core/core.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

class DitontonApp extends StatelessWidget {
  final List<NavigatorObserver> navigatorObservers;
  final VoidCallback? onTestCrash;

  const DitontonApp({
    super.key,
    this.navigatorObservers = const [],
    this.onTestCrash,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SeasonEpisodesBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        navigatorObservers: [routeObserver, ...navigatorObservers],
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Route<dynamic> material(Widget page) {
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    }

    Route<dynamic> cupertino(Widget page) {
      return CupertinoPageRoute(builder: (_) => page, settings: settings);
    }

    return switch (settings.name) {
      homeMovieRoute => material(const HomeMoviePage()),
      popularMoviesRoute => cupertino(const PopularMoviesPage()),
      topRatedMoviesRoute => cupertino(const TopRatedMoviesPage()),
      movieDetailRoute => material(
        MovieDetailPage(id: settings.arguments as int),
      ),
      searchMoviesRoute => cupertino(const MovieSearchPage()),
      watchlistMoviesRoute => material(const WatchlistMoviesPage()),
      homeTvSeriesRoute => material(const HomeTvSeriesPage()),
      onTheAirTvSeriesRoute => cupertino(const OnTheAirTvSeriesPage()),
      popularTvSeriesRoute => cupertino(const PopularTvSeriesPage()),
      topRatedTvSeriesRoute => cupertino(const TopRatedTvSeriesPage()),
      tvSeriesDetailRoute => material(
        TvSeriesDetailPage(id: settings.arguments as int),
      ),
      searchTvSeriesRoute => cupertino(const TvSeriesSearchPage()),
      watchlistTvSeriesRoute => material(const WatchlistTvSeriesPage()),
      aboutRoute => material(AboutPage(onTestCrash: onTestCrash)),
      _ => material(
        const Scaffold(body: Center(child: Text('Page not found :('))),
      ),
    };
  }
}
