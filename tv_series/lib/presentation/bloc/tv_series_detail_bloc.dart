import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<AddTvSeriesToWatchlist>(_onAddTvSeriesToWatchlist);
    on<RemoveTvSeriesFromWatchlist>(_onRemoveTvSeriesFromWatchlist);
  }

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(const TvSeriesDetailState(tvSeriesState: RequestState.loading));

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult = await getTvSeriesRecommendations.execute(
      event.id,
    );
    final isAddedToWatchlist = await getWatchlistStatusTvSeries.execute(
      event.id,
    );

    detailResult.fold(
      (failure) => emit(
        state.copyWith(
          tvSeriesState: RequestState.error,
          message: failure.message,
        ),
      ),
      (tvSeries) {
        final loaded = state.copyWith(
          tvSeriesState: RequestState.loaded,
          tvSeries: tvSeries,
          isAddedToWatchlist: isAddedToWatchlist,
        );
        emit(
          recommendationResult.fold(
            (failure) => loaded.copyWith(
              recommendationState: RequestState.error,
              message: failure.message,
            ),
            (recommendations) => loaded.copyWith(
              recommendationState: RequestState.loaded,
              recommendations: recommendations,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddTvSeriesToWatchlist(
    AddTvSeriesToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(watchlistMessage: ''));
    final result = await saveWatchlistTvSeries.execute(event.tvSeries);
    await _emitWatchlistResult(result, event.tvSeries.id, emit);
  }

  Future<void> _onRemoveTvSeriesFromWatchlist(
    RemoveTvSeriesFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(watchlistMessage: ''));
    final result = await removeWatchlistTvSeries.execute(event.tvSeries);
    await _emitWatchlistResult(result, event.tvSeries.id, emit);
  }

  Future<void> _emitWatchlistResult(
    Either<Failure, String> result,
    int id,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final message = result.fold((failure) => failure.message, (text) => text);
    final isAddedToWatchlist = await getWatchlistStatusTvSeries.execute(id);
    emit(
      state.copyWith(
        watchlistMessage: message,
        isAddedToWatchlist: isAddedToWatchlist,
      ),
    );
  }
}
