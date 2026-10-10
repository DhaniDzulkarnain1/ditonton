import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';

class _FakeAssetBundle extends CachingAssetBundle {
  final Map<String, List<int>> assets;

  _FakeAssetBundle(this.assets);

  @override
  Future<ByteData> load(String key) async {
    final bytes = assets[key];
    if (bytes == null) {
      throw StateError('Unable to load asset: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  final certificateBytes = File(
    'assets/certificates/tmdb.pem',
  ).readAsBytesSync();

  test('certificate path should point to the bundled core asset', () {
    expect(
      SslPinning.certificatePath,
      'packages/core/assets/certificates/tmdb.pem',
    );
  });

  test('should create an HttpClient from a valid certificate', () {
    final client = SslPinning.createHttpClient(certificateBytes);

    expect(client, isA<HttpClient>());
    client.close();
  });

  test('should reject bytes that are not a certificate', () {
    expect(
      () => SslPinning.createHttpClient('not a certificate'.codeUnits),
      throwsA(isA<TlsException>()),
    );
  });

  test('should create a pinned client from the bundled certificate', () async {
    final bundle = _FakeAssetBundle({
      SslPinning.certificatePath: certificateBytes,
    });

    final client = await SslPinning.createClient(bundle: bundle);

    expect(client, isA<IOClient>());
    client.close();
  });

  test('should fail when the certificate asset is missing', () {
    expect(
      () => SslPinning.createClient(bundle: _FakeAssetBundle({})),
      throwsStateError,
    );
  });
}
