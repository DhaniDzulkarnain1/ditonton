part of 'movie_detail_bloc.dart';

sealed class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
