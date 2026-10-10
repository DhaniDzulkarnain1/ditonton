import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';
import 'package:tv_series/presentation/bloc/tv_series_search_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_series_list_view.dart';

class TvSeriesSearchPage extends StatelessWidget {
  const TvSeriesSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TvSeriesSearchBloc>().add(
                  TvSeriesSearchSubmitted(query),
                );
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            Expanded(
              child: BlocBuilder<TvSeriesSearchBloc, TvSeriesListState>(
                builder: (context, state) => TvSeriesListView(state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
