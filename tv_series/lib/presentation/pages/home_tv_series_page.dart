import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/on_the_air_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_poster_list.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({super.key});

  @override
  State<HomeTvSeriesPage> createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnTheAirTvSeriesBloc>().add(const FetchOnTheAirTvSeries());
    context.read<PopularTvSeriesBloc>().add(const FetchPopularTvSeries());
    context.read<TopRatedTvSeriesBloc>().add(const FetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        currentRoute: homeTvSeriesRoute,
        watchlistRoute: watchlistTvSeriesRoute,
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, searchTvSeriesRoute),
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
              SubHeading(
                title: 'On The Air',
                onTap: () =>
                    Navigator.pushNamed(context, onTheAirTvSeriesRoute),
              ),
              BlocBuilder<OnTheAirTvSeriesBloc, TvSeriesListState>(
                builder: (context, state) => _TvSeriesSection(state),
              ),
              SubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, popularTvSeriesRoute),
              ),
              BlocBuilder<PopularTvSeriesBloc, TvSeriesListState>(
                builder: (context, state) => _TvSeriesSection(state),
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, topRatedTvSeriesRoute),
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TvSeriesListState>(
                builder: (context, state) => _TvSeriesSection(state),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TvSeriesSection extends StatelessWidget {
  final TvSeriesListState state;

  const _TvSeriesSection(this.state);

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      TvSeriesListLoading() => const Center(child: CircularProgressIndicator()),
      TvSeriesListHasData(:final tvSeries) => TvSeriesPosterList(tvSeries),
      TvSeriesListError() => const Text('Failed'),
      TvSeriesListEmpty() => const SizedBox.shrink(),
    };
  }
}
