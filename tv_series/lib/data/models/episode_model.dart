import 'package:tv_series/domain/entities/episode.dart';
import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  const EpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.stillPath,
    required this.voteAverage,
  });

  final String? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final String? stillPath;
  final double voteAverage;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
    airDate: json['air_date'],
    episodeNumber: json['episode_number'],
    id: json['id'],
    name: json['name'],
    overview: json['overview'],
    stillPath: json['still_path'],
    voteAverage: json['vote_average'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episode_number': episodeNumber,
    'id': id,
    'name': name,
    'overview': overview,
    'still_path': stillPath,
    'vote_average': voteAverage,
  };

  Episode toEntity() {
    return Episode(
      airDate: airDate,
      episodeNumber: episodeNumber,
      id: id,
      name: name,
      overview: overview,
      stillPath: stillPath,
      voteAverage: voteAverage,
    );
  }

  @override
  List<Object?> get props => [
    airDate,
    episodeNumber,
    id,
    name,
    overview,
    stillPath,
    voteAverage,
  ];
}
