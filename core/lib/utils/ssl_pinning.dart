import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinning {
  static const String certificatePath =
      'packages/core/assets/certificates/tmdb.pem';

  static Future<http.Client> createClient({AssetBundle? bundle}) async {
    final certificates = await (bundle ?? rootBundle).load(certificatePath);
    return IOClient(createHttpClient(certificates.buffer.asUint8List()));
  }

  static HttpClient createHttpClient(List<int> certificateBytes) {
    final context = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certificateBytes);
    return HttpClient(context: context);
  }
}
