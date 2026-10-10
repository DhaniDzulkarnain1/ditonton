import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  factory MovieListState.fromResult(Either<Failure, List<Movie>> result) {
    return result.fold(
      (failure) => MovieListError(failure.message),
      (movies) => MovieListHasData(movies),
    );
  }

  @override
  List<Object> get props => [];
}

class MovieListEmpty extends MovieListState {
  const MovieListEmpty();
}

class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

class MovieListHasData extends MovieListState {
  final List<Movie> movies;

  const MovieListHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieListError extends MovieListState {
  final String message;

  const MovieListError(this.message);

  @override
  List<Object> get props => [message];
}
