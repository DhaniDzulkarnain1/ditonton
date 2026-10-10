import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/on_the_air_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';
import 'package:tv_series/presentation/widgets/tv_series_list_view.dart';

class OnTheAirTvSeriesPage extends StatefulWidget {
  const OnTheAirTvSeriesPage({super.key});

  @override
  State<OnTheAirTvSeriesPage> createState() => _OnTheAirTvSeriesPageState();
}

class _OnTheAirTvSeriesPageState extends State<OnTheAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnTheAirTvSeriesBloc>().add(const FetchOnTheAirTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvSeriesBloc, TvSeriesListState>(
          builder: (context, state) => TvSeriesListView(state),
        ),
      ),
    );
  }
}
