import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Action');
  const tGenreJson = {'id': 1, 'name': 'Action'};

  test('fromJson should return a valid model', () {
    expect(GenreModel.fromJson(tGenreJson), tGenreModel);
  });

  test('toJson should return a JSON map containing proper data', () {
    expect(tGenreModel.toJson(), tGenreJson);
  });

  test('toEntity should return a Genre entity', () {
    expect(tGenreModel.toEntity(), const Genre(id: 1, name: 'Action'));
  });
}
