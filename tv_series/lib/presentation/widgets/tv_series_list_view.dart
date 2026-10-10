import 'package:flutter/material.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';

class TvSeriesListView extends StatelessWidget {
  final TvSeriesListState state;

  const TvSeriesListView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      TvSeriesListLoading() => const Center(child: CircularProgressIndicator()),
      TvSeriesListHasData(:final tvSeries) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: tvSeries.length,
        itemBuilder: (context, index) => TvSeriesCard(tvSeries[index]),
      ),
      TvSeriesListError(:final message) => Center(
        key: const Key('error_message'),
        child: Text(message),
      ),
      TvSeriesListEmpty() => const SizedBox.shrink(),
    };
  }
}
