import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

class GetSeasonDetails {
  final TvSeriesRepository repository;

  GetSeasonDetails(this.repository);

  Future<Either<Failure, List<Episode>>> execute(int tvId, int seasonNumber) {
    return repository.getSeasonDetails(tvId, seasonNumber);
  }
}
