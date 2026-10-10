import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
  }

  void _showWatchlistMessage(BuildContext context, String message) {
    final isSuccess =
        message == watchlistAddSuccessMessage ||
        message == watchlistRemoveSuccessMessage;

    if (isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistMessage != current.watchlistMessage &&
            current.watchlistMessage.isNotEmpty,
        listener: (context, state) =>
            _showWatchlistMessage(context, state.watchlistMessage),
        builder: (context, state) {
          final movie = state.movie;
          if (state.movieState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.movieState == RequestState.loaded && movie != null) {
            return SafeArea(child: MovieDetailContent(movie, state));
          } else {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          }
        },
      ),
    );
  }
}

class MovieDetailContent extends StatelessWidget {
  final MovieDetail movie;
  final MovieDetailState state;

  const MovieDetailContent(this.movie, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: _buildDetails(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: kHeading5),
        FilledButton(
          onPressed: () {
            context.read<MovieDetailBloc>().add(
              state.isAddedToWatchlist
                  ? RemoveMovieFromWatchlist(movie)
                  : AddMovieToWatchlist(movie),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(state.isAddedToWatchlist ? Icons.check : Icons.add),
              const Text('Watchlist'),
            ],
          ),
        ),
        Text(movie.genres.map((genre) => genre.name).join(', ')),
        Text(_formatDuration(movie.runtime)),
        Row(
          children: [
            RatingBarIndicator(
              rating: movie.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: kMikadoYellow),
              itemSize: 24,
            ),
            Text('${movie.voteAverage}'),
          ],
        ),
        const SizedBox(height: 16),
        Text('Overview', style: kHeading6),
        Text(movie.overview),
        const SizedBox(height: 16),
        Text('Recommendations', style: kHeading6),
        _buildRecommendations(),
      ],
    );
  }

  Widget _buildRecommendations() {
    return switch (state.recommendationState) {
      RequestState.loading => const Center(child: CircularProgressIndicator()),
      RequestState.error => Text(state.message),
      RequestState.loaded => _RecommendationList(state.recommendations),
      RequestState.empty => const SizedBox.shrink(),
    };
  }

  String _formatDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}

class _RecommendationList extends StatelessWidget {
  final List<Movie> recommendations;

  const _RecommendationList(this.recommendations);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final movie = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  movieDetailRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
