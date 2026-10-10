part of 'tv_series_detail_bloc.dart';

sealed class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddTvSeriesToWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
