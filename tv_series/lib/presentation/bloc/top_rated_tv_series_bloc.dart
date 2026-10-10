import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';

class FetchTopRatedTvSeries extends Equatable {
  const FetchTopRatedTvSeries();

  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesBloc
    extends Bloc<FetchTopRatedTvSeries, TvSeriesListState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this.getTopRatedTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());
      final result = await getTopRatedTvSeries.execute();
      emit(TvSeriesListState.fromResult(result));
    });
  }
}
