import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/widgets/season_list.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;

  const TvSeriesDetailPage({super.key, required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
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
      body: BlocConsumer<TvSeriesDetailBloc, TvSeriesDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistMessage != current.watchlistMessage &&
            current.watchlistMessage.isNotEmpty,
        listener: (context, state) =>
            _showWatchlistMessage(context, state.watchlistMessage),
        builder: (context, state) {
          final tvSeries = state.tvSeries;
          if (state.tvSeriesState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tvSeriesState == RequestState.loaded &&
              tvSeries != null) {
            return SafeArea(child: TvSeriesDetailContent(tvSeries, state));
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

class TvSeriesDetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final TvSeriesDetailState state;

  const TvSeriesDetailContent(this.tvSeries, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
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
        Text(tvSeries.name, style: kHeading5),
        FilledButton(
          onPressed: () {
            context.read<TvSeriesDetailBloc>().add(
              state.isAddedToWatchlist
                  ? RemoveTvSeriesFromWatchlist(tvSeries)
                  : AddTvSeriesToWatchlist(tvSeries),
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
        Text(tvSeries.genres.map((genre) => genre.name).join(', ')),
        Text('First Air Date: ${tvSeries.firstAirDate}'),
        Row(
          children: [
            RatingBarIndicator(
              rating: tvSeries.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: kMikadoYellow),
              itemSize: 24,
            ),
            Text('${tvSeries.voteAverage}'),
          ],
        ),
        const SizedBox(height: 16),
        Text('Overview', style: kHeading6),
        Text(tvSeries.overview),
        const SizedBox(height: 16),
        Text(
          'Seasons (${tvSeries.numberOfSeasons} seasons, '
          '${tvSeries.numberOfEpisodes} episodes)',
          style: kHeading6,
        ),
        const SizedBox(height: 8),
        SeasonList(tvSeriesId: tvSeries.id, seasons: tvSeries.seasons),
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
}

class _RecommendationList extends StatelessWidget {
  final List<TvSeries> recommendations;

  const _RecommendationList(this.recommendations);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final tvSeries = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  tvSeriesDetailRoute,
                  arguments: tvSeries.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tvSeries.posterPath}',
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
