import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';

class FetchPopularTvSeries extends Equatable {
  const FetchPopularTvSeries();

  @override
  List<Object> get props => [];
}

class PopularTvSeriesBloc
    extends Bloc<FetchPopularTvSeries, TvSeriesListState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc(this.getPopularTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());
      final result = await getPopularTvSeries.execute();
      emit(TvSeriesListState.fromResult(result));
    });
  }
}
