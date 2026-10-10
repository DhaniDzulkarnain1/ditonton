import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/usecases/get_season_details.dart';

class FetchSeasonEpisodes extends Equatable {
  final int tvSeriesId;
  final int seasonNumber;

  const FetchSeasonEpisodes(this.tvSeriesId, this.seasonNumber);

  @override
  List<Object> get props => [tvSeriesId, seasonNumber];
}

class SeasonEpisodes extends Equatable {
  final RequestState requestState;
  final List<Episode> episodes;
  final String message;

  const SeasonEpisodes({
    this.requestState = RequestState.empty,
    this.episodes = const [],
    this.message = '',
  });

  @override
  List<Object> get props => [requestState, episodes, message];
}

class SeasonEpisodesState extends Equatable {
  final int? tvSeriesId;
  final Map<int, SeasonEpisodes> seasons;

  const SeasonEpisodesState({this.tvSeriesId, this.seasons = const {}});

  SeasonEpisodes season(int seasonNumber) {
    return seasons[seasonNumber] ?? const SeasonEpisodes();
  }

  SeasonEpisodesState withSeason(
    int tvSeriesId,
    int seasonNumber,
    SeasonEpisodes season,
  ) {
    final current = tvSeriesId == this.tvSeriesId ? seasons : const {};
    return SeasonEpisodesState(
      tvSeriesId: tvSeriesId,
      seasons: {...current, seasonNumber: season},
    );
  }

  @override
  List<Object?> get props => [tvSeriesId, seasons];
}

class SeasonEpisodesBloc
    extends Bloc<FetchSeasonEpisodes, SeasonEpisodesState> {
  final GetSeasonDetails getSeasonDetails;

  SeasonEpisodesBloc(this.getSeasonDetails)
    : super(const SeasonEpisodesState()) {
    on<FetchSeasonEpisodes>(_onFetchSeasonEpisodes);
  }

  Future<void> _onFetchSeasonEpisodes(
    FetchSeasonEpisodes event,
    Emitter<SeasonEpisodesState> emit,
  ) async {
    final isSameTvSeries = state.tvSeriesId == event.tvSeriesId;
    final cached = state.season(event.seasonNumber).requestState;
    if (isSameTvSeries && cached == RequestState.loaded) {
      return;
    }

    emit(
      state.withSeason(
        event.tvSeriesId,
        event.seasonNumber,
        const SeasonEpisodes(requestState: RequestState.loading),
      ),
    );

    final result = await getSeasonDetails.execute(
      event.tvSeriesId,
      event.seasonNumber,
    );

    emit(
      state.withSeason(
        event.tvSeriesId,
        event.seasonNumber,
        result.fold(
          (failure) => SeasonEpisodes(
            requestState: RequestState.error,
            message: failure.message,
          ),
          (episodes) => SeasonEpisodes(
            requestState: RequestState.loaded,
            episodes: episodes,
          ),
        ),
      ),
    );
  }
}
