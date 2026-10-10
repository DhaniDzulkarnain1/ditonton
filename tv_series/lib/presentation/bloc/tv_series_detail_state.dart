part of 'tv_series_detail_bloc.dart';

class TvSeriesDetailState extends Equatable {
  final RequestState tvSeriesState;
  final TvSeriesDetail? tvSeries;
  final RequestState recommendationState;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const TvSeriesDetailState({
    this.tvSeriesState = RequestState.empty,
    this.tvSeries,
    this.recommendationState = RequestState.empty,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  TvSeriesDetailState copyWith({
    RequestState? tvSeriesState,
    TvSeriesDetail? tvSeries,
    RequestState? recommendationState,
    List<TvSeries>? recommendations,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeries: tvSeries ?? this.tvSeries,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tvSeriesState,
    tvSeries,
    recommendationState,
    recommendations,
    isAddedToWatchlist,
    message,
    watchlistMessage,
  ];
}
