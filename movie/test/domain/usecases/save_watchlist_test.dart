import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(mockMovieRepository);
  });

  test('should save movie to the repository', () async {
    when(
      () => mockMovieRepository.saveWatchlist(testMovieDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    final result = await usecase.execute(testMovieDetail);
    verify(() => mockMovieRepository.saveWatchlist(testMovieDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
