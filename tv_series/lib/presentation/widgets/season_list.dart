import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/presentation/bloc/season_episodes_bloc.dart';

class SeasonList extends StatelessWidget {
  final int tvSeriesId;
  final List<Season> seasons;

  const SeasonList({
    super.key,
    required this.tvSeriesId,
    required this.seasons,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeasonEpisodesBloc, SeasonEpisodesState>(
      builder: (context, state) {
        final isCurrentTvSeries = state.tvSeriesId == tvSeriesId;
        return Column(
          children: [
            for (final season in seasons)
              _SeasonTile(
                season: season,
                seasonEpisodes: isCurrentTvSeries
                    ? state.season(season.seasonNumber)
                    : const SeasonEpisodes(),
                onExpanded: () {
                  context.read<SeasonEpisodesBloc>().add(
                    FetchSeasonEpisodes(tvSeriesId, season.seasonNumber),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _SeasonTile extends StatelessWidget {
  final Season season;
  final SeasonEpisodes seasonEpisodes;
  final VoidCallback onExpanded;

  const _SeasonTile({
    required this.season,
    required this.seasonEpisodes,
    required this.onExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final airDate = season.airDate ?? '';
    return Material(
      color: Colors.transparent,
      child: ExpansionTile(
        title: Text(
          season.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${season.episodeCount} episodes'),
        onExpansionChanged: (expanded) {
          if (expanded) {
            onExpanded();
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (airDate.isNotEmpty) Text('Air Date: $airDate'),
                const SizedBox(height: 8),
                Text(
                  season.overview.isNotEmpty
                      ? season.overview
                      : 'No overview available',
                ),
                const SizedBox(height: 16),
                _buildEpisodes(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodes() {
    return switch (seasonEpisodes.requestState) {
      RequestState.loading => const Center(child: CircularProgressIndicator()),
      RequestState.error => const Text('Failed to load episodes'),
      RequestState.loaded => _EpisodeList(seasonEpisodes.episodes),
      RequestState.empty => const SizedBox.shrink(),
    };
  }
}

class _EpisodeList extends StatelessWidget {
  final List<Episode> episodes;

  const _EpisodeList(this.episodes);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Episodes:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        for (final episode in episodes) _EpisodeCard(episode),
      ],
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  static const int _maxOverviewLength = 100;

  final Episode episode;

  const _EpisodeCard(this.episode);

  String get _overview {
    final overview = episode.overview;
    if (overview.isEmpty) {
      return 'No overview available';
    }
    return overview.length > _maxOverviewLength
        ? '${overview.substring(0, _maxOverviewLength)}...'
        : overview;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _EpisodeStill(episode.stillPath),
        title: Text('${episode.episodeNumber}. ${episode.name}'),
        subtitle: Text(_overview, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: episode.voteAverage > 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(episode.voteAverage.toStringAsFixed(1)),
                ],
              )
            : null,
      ),
    );
  }
}

class _EpisodeStill extends StatelessWidget {
  static const double _width = 80;
  static const double _height = 45;

  final String? stillPath;

  const _EpisodeStill(this.stillPath);

  Widget _placeholder(Widget child) {
    return Container(
      width: _width,
      height: _height,
      color: Colors.grey[800],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (stillPath == null) {
      return _placeholder(const Icon(Icons.image, size: 20));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: '$baseStillImageUrl$stillPath',
        width: _width,
        height: _height,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            _placeholder(const Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) =>
            _placeholder(const Icon(Icons.image, size: 20)),
      ),
    );
  }
}
