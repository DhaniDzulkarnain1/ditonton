import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';
import 'package:movie/presentation/widgets/movie_card.dart';

class MovieListView extends StatelessWidget {
  final MovieListState state;

  const MovieListView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      MovieListLoading() => const Center(child: CircularProgressIndicator()),
      MovieListHasData(:final movies) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: movies.length,
        itemBuilder: (context, index) => MovieCard(movies[index]),
      ),
      MovieListError(:final message) => Center(
        key: const Key('error_message'),
        child: Text(message),
      ),
      MovieListEmpty() => const SizedBox.shrink(),
    };
  }
}
