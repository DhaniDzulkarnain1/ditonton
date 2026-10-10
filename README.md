# Ditonton

[![CI](https://github.com/DhaniDzulkarnain1/ditonton/actions/workflows/ci.yml/badge.svg)](https://github.com/DhaniDzulkarnain1/ditonton/actions/workflows/ci.yml)

Aplikasi katalog film dan TV series berbasis Flutter yang mengambil data dari [The Movie Database (TMDB)](https://www.themoviedb.org/). Proyek ini merupakan submission akhir kelas **Menjadi Flutter Developer Expert** di Dicoding.

## Fitur

- Daftar film: Now Playing, Popular, dan Top Rated.
- Daftar TV series: On The Air, Popular, dan Top Rated.
- Detail film dan TV series beserta rekomendasi.
- Detail season dan episode pada TV series.
- Pencarian film dan TV series.
- Watchlist film dan TV series yang tersimpan di database lokal.

## Arsitektur

Proyek menerapkan Clean Architecture dan dibagi menjadi beberapa modul:

| Modul | Isi |
| --- | --- |
| `core` | Style, konstanta, rute, failure, database helper, SSL pinning, dan widget bersama. |
| `movie` | Layer data, domain, dan presentation untuk fitur film. |
| `tv_series` | Layer data, domain, dan presentation untuk fitur TV series, season, dan episode. |
| `lib` (root) | Entry point, dependency injection, routing, dan integrasi Firebase. |

Teknologi utama:

- **State management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc).
- **Dependency injection**: [get_it](https://pub.dev/packages/get_it).
- **SSL pinning**: sertifikat `api.themoviedb.org` dipasang melalui `SecurityContext` di `core/lib/utils/ssl_pinning.dart`.
- **Firebase**: Analytics untuk mencatat perpindahan halaman dan Crashlytics untuk laporan eror.
- **Continuous Integration**: GitHub Actions menjalankan analyzer, seluruh pengujian, dan build APK pada setiap push. Konfigurasi Codemagic tersedia di `codemagic.yaml`.

## Menjalankan Aplikasi

Proyek memakai Flutter channel stable terbaru melalui [FVM](https://fvm.app/).

```
fvm install
fvm flutter pub get
fvm flutter run
```

## Pengujian

Jalankan seluruh unit test dan widget test beserta laporan coverage:

```
./test.sh
```

Atau jalankan per modul:

```
cd movie
fvm flutter test --coverage
```

Integration test membutuhkan emulator atau perangkat yang terhubung:

```
fvm flutter test integration_test
```
