import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('failures with the same message should be equal', () {
    expect(const ServerFailure('error'), const ServerFailure('error'));
    expect(const ConnectionFailure('error'), const ConnectionFailure('error'));
    expect(const DatabaseFailure('error'), const DatabaseFailure('error'));
  });

  test('failures of different types should not be equal', () {
    expect(const ServerFailure('error'), isNot(const DatabaseFailure('error')));
  });

  test('failure should expose its message', () {
    expect(const ServerFailure('error').message, 'error');
    expect(const ServerFailure('error').props, ['error']);
  });

  test('DatabaseException should expose its message', () {
    expect(DatabaseException('error').message, 'error');
    expect(ServerException(), isA<Exception>());
  });
}
