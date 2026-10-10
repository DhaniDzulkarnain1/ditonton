part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final RequestState movieState;
  final MovieDetail? movie;
  final RequestState recommendationState;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const MovieDetailState({
    this.movieState = RequestState.empty,
    this.movie,
    this.recommendationState = RequestState.empty,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    RequestState? movieState,
    MovieDetail? movie,
    RequestState? recommendationState,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieState: movieState ?? this.movieState,
      movie: movie ?? this.movie,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movieState,
    movie,
    recommendationState,
    recommendations,
    isAddedToWatchlist,
    message,
    watchlistMessage,
  ];
}
