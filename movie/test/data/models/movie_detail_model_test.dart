import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/domain/entities/movie_detail.dart';

import '../../json_reader.dart';

void main() {
  final Map<String, dynamic> tJson = json.decode(
    readJson('dummy_data/movie_detail.json'),
  );
  final tModel = MovieDetailResponse.fromJson(tJson);

  test('fromJson should return a valid model from JSON', () {
    expect(tModel.id, tJson['id']);
    expect(tModel.title, tJson['title']);
    expect(tModel.genres, isA<List<GenreModel>>());
  });

  test('toJson should return a JSON map containing proper data', () {
    final result = tModel.toJson();

    expect(MovieDetailResponse.fromJson(result), tModel);
    expect(result['id'], tJson['id']);
    expect(result['title'], tJson['title']);
  });

  test('toEntity should return a MovieDetail entity', () {
    final result = tModel.toEntity();

    expect(result, isA<MovieDetail>());
    expect(result.id, tModel.id);
    expect(result.genres.length, tModel.genres.length);
  });
}
