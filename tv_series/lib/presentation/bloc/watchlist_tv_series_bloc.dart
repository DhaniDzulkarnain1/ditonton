import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';

class FetchWatchlistTvSeries extends Equatable {
  const FetchWatchlistTvSeries();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesBloc
    extends Bloc<FetchWatchlistTvSeries, TvSeriesListState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this.getWatchlistTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());
      final result = await getWatchlistTvSeries.execute();
      emit(TvSeriesListState.fromResult(result));
    });
  }
}
