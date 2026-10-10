import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';

class FetchOnTheAirTvSeries extends Equatable {
  const FetchOnTheAirTvSeries();

  @override
  List<Object> get props => [];
}

class OnTheAirTvSeriesBloc
    extends Bloc<FetchOnTheAirTvSeries, TvSeriesListState> {
  final GetOnTheAirTvSeries getOnTheAirTvSeries;

  OnTheAirTvSeriesBloc(this.getOnTheAirTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchOnTheAirTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());
      final result = await getOnTheAirTvSeries.execute();
      emit(TvSeriesListState.fromResult(result));
    });
  }
}
