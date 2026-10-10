import 'package:core/core.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailResponse extends Equatable {
  const TvSeriesDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.seasons,
  });

  final String? backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String originalName;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<SeasonModel> seasons;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        backdropPath: json['backdrop_path'],
        genres: List<GenreModel>.from(
          json['genres'].map((x) => GenreModel.fromJson(x)),
        ),
        id: json['id'],
        originalName: json['original_name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        firstAirDate: json['first_air_date'],
        name: json['name'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
        seasons: List<SeasonModel>.from(
          json['seasons'].map((x) => SeasonModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    'backdrop_path': backdropPath,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'id': id,
    'original_name': originalName,
    'overview': overview,
    'poster_path': posterPath,
    'first_air_date': firstAirDate,
    'name': name,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
  };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      seasons: seasons.map((season) => season.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    genres,
    id,
    originalName,
    overview,
    posterPath,
    firstAirDate,
    name,
    voteAverage,
    voteCount,
    numberOfEpisodes,
    numberOfSeasons,
    seasons,
  ];
}
