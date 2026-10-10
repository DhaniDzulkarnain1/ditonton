import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_state.dart';

class TvSeriesSearchSubmitted extends Equatable {
  final String query;

  const TvSeriesSearchSubmitted(this.query);

  @override
  List<Object> get props => [query];
}

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchSubmitted, TvSeriesListState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc(this.searchTvSeries) : super(const TvSeriesListEmpty()) {
    on<TvSeriesSearchSubmitted>((event, emit) async {
      emit(const TvSeriesListLoading());
      final result = await searchTvSeries.execute(event.query);
      emit(TvSeriesListState.fromResult(result));
    });
  }
}
