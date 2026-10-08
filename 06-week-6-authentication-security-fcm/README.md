# Campus Notify — Minggu 6

Implementasi codelab [Authentication, Security & FCM](https://jti-polinema.github.io/flutter-codelab/06-minggu-6-authentication-security-fcm/index.html) bagian #0 sampai #7.

## Fitur

- Login mock dengan route guard GoRouter.
- Access token dan refresh token hanya disimpan melalui `flutter_secure_storage`.
- Dio menambahkan bearer token, melakukan refresh maksimal satu kali saat 401, lalu membersihkan sesi bila refresh gagal.
- Pemetaan error API ke pesan yang aman untuk UI.
- `PushService` untuk permission, token lifecycle, topic `pengumuman-kampus`, foreground local notification, background handler top-level, dan deep link dari foreground/background/terminated.
- Rute deep link dipusatkan di `lib/routes.dart` dan parser payload FCM dapat diuji tanpa Firebase.

## Menjalankan

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```


## Matriks pengujian FCM

| State | Expected | Bukti |
| --- | --- | --- |
| Foreground | Banner lokal muncul; klik menuju `/pengumuman/3` | Uji dengan app terbuka dan kirim campaign |
| Background | Banner sistem muncul; klik menuju `/pengumuman/3` | Tekan Home, kirim campaign, klik banner |
| Terminated | App dibuka menuju `/pengumuman/3` | Swipe-close app, kirim campaign, klik banner |

FCM asli membutuhkan perangkat Android dengan Google Play Services atau perangkat iOS dengan APNs. Screenshot bukti dapat ditambahkan ke folder `screenshots/` setelah pengujian pada perangkat.

## Keputusan keamanan dan AI verification

- Refresh token tidak disimpan di SharedPreferences karena storage tersebut tidak ditujukan untuk rahasia.
- `onTokenRefresh` langsung meneruskan token baru ke callback backend agar token basi tidak tertinggal.
- Personal message memakai device token; topic hanya untuk broadcast seperti pengumuman kampus.
- Tidak ada secret Firebase atau token pengguna yang di-hardcode ke source control.
- Draf FCM ditolak jika background handler bukan top-level, jika token hanya dicetak, atau jika foreground tidak menampilkan local notification.
