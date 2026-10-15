# Week 7: Clean Architecture

Refactor `campus_notify` menjadi feature-first Clean Architecture.

## Struktur

Setiap feature memiliki tiga layer:

- `domain`: entity, repository contract, dan use case. Tidak bergantung pada Flutter.
- `data`: model dan implementasi repository, termasuk secure storage untuk auth.
- `presentation`: halaman dan Riverpod providers sebagai dependency injection.

Dependency mengarah ke dalam: presentation bergantung pada domain, sedangkan domain
tidak mengetahui Flutter, storage, atau implementasi data source.

## Feature yang selesai

- `announcements`: daftar dan detail pengumuman melalui `GetAnnouncements` dan `GetAnnouncement`.
- `auth`: login mock, session check, logout, dan token storage melalui `Login`.
- GoRouter guard mengarahkan user tanpa session ke `/login`.
- `formatDate` dan `routeFromMessage` dipisahkan sebagai pure functions.

## Verifikasi

```text
flutter analyze
flutter test
```

Test domain memakai `FakeAnnouncementRepository`, tanpa network atau database nyata.

## Keputusan dan trade-off

Repository dipisahkan per feature agar kontrak domain mudah diuji dan data source dapat
diganti. Untuk aplikasi kecil, jumlah folder memang lebih banyak, tetapi batas layer
membuat perubahan secure storage atau UI tidak menyebar ke use case. Data source masih
mock karena target Week 7 adalah refactor arsitektur dari Week 6, bukan penambahan backend.
