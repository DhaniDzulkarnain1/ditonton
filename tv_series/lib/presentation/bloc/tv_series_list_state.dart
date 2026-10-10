import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

sealed class TvSeriesListState extends Equatable {
  const TvSeriesListState();

  factory TvSeriesListState.fromResult(Either<Failure, List<TvSeries>> result) {
    return result.fold(
      (failure) => TvSeriesListError(failure.message),
      (tvSeries) => TvSeriesListHasData(tvSeries),
    );
  }

  @override
  List<Object> get props => [];
}

class TvSeriesListEmpty extends TvSeriesListState {
  const TvSeriesListEmpty();
}

class TvSeriesListLoading extends TvSeriesListState {
  const TvSeriesListLoading();
}

class TvSeriesListHasData extends TvSeriesListState {
  final List<TvSeries> tvSeries;

  const TvSeriesListHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesListError extends TvSeriesListState {
  final String message;

  const TvSeriesListError(this.message);

  @override
  List<Object> get props => [message];
}
