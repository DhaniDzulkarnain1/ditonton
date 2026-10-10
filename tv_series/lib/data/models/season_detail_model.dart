import 'package:tv_series/data/models/episode_model.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  const SeasonDetailResponse({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.seasonNumber,
  });

  final String id;
  final String? airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final int seasonNumber;

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json['_id'],
        airDate: json['air_date'],
        episodes: List<EpisodeModel>.from(
          json['episodes'].map((x) => EpisodeModel.fromJson(x)),
        ),
        name: json['name'],
        overview: json['overview'],
        seasonNumber: json['season_number'],
      );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'air_date': airDate,
    'episodes': List<dynamic>.from(episodes.map((x) => x.toJson())),
    'name': name,
    'overview': overview,
    'season_number': seasonNumber,
  };

  @override
  List<Object?> get props => [
    id,
    airDate,
    episodes,
    name,
    overview,
    seasonNumber,
  ];
}
