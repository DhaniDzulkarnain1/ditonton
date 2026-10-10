import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_list_view.dart';

class PopularTvSeriesPage extends StatefulWidget {
  const PopularTvSeriesPage({super.key});

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularTvSeriesBloc>().add(const FetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, TvSeriesListState>(
          builder: (context, state) => TvSeriesListView(state),
        ),
      ),
    );
  }
}
