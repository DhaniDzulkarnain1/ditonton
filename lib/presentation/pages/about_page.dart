import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final VoidCallback? onTestCrash;

  const AboutPage({super.key, this.onTestCrash});

  @override
  Widget build(BuildContext context) {
    final onTestCrash = this.onTestCrash;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: kPrussianBlue,
                  child: Center(
                    child: Image.asset(
                      logoAssetPath,
                      package: corePackageName,
                      width: 128,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  color: kMikadoYellow,
                  child: Column(
                    children: [
                      const Text(
                        'Ditonton merupakan sebuah aplikasi katalog film yang '
                        'dikembangkan oleh Dicoding Indonesia sebagai contoh '
                        'proyek aplikasi untuk kelas Menjadi Flutter Developer '
                        'Expert.',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      if (onTestCrash != null)
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: onTestCrash,
                          child: const Text('Test Crashlytics'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
