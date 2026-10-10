import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';
import 'package:movie/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/presentation/widgets/movie_poster_list.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    context.read<NowPlayingMoviesBloc>().add(const FetchNowPlayingMovies());
    context.read<PopularMoviesBloc>().add(const FetchPopularMovies());
    context.read<TopRatedMoviesBloc>().add(const FetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        currentRoute: homeMovieRoute,
        watchlistRoute: watchlistMoviesRoute,
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, searchMoviesRoute),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<NowPlayingMoviesBloc, MovieListState>(
                builder: (context, state) => _MovieSection(state),
              ),
              SubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, popularMoviesRoute),
              ),
              BlocBuilder<PopularMoviesBloc, MovieListState>(
                builder: (context, state) => _MovieSection(state),
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(context, topRatedMoviesRoute),
              ),
              BlocBuilder<TopRatedMoviesBloc, MovieListState>(
                builder: (context, state) => _MovieSection(state),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieSection extends StatelessWidget {
  final MovieListState state;

  const _MovieSection(this.state);

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      MovieListLoading() => const Center(child: CircularProgressIndicator()),
      MovieListHasData(:final movies) => MoviePosterList(movies),
      MovieListError() => const Text('Failed'),
      MovieListEmpty() => const SizedBox.shrink(),
    };
  }
}
