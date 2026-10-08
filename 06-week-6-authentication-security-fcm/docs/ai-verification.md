# AI Verification

## Prompt yang digunakan

> Buatkan PushService Flutter dengan permission, getToken, onTokenRefresh yang mengirim ke `POST /devices`, foreground local notification, handler background top-level, `onMessageOpenedApp`, `getInitialMessage`, dan topic `pengumuman-kampus`. Tandai bagian yang tidak boleh mengakses `BuildContext`.

## Pemeriksaan manual

| Pemeriksaan | Keputusan |
| --- | --- |
| Background handler top-level dan memakai `@pragma('vm:entry-point')` | Lulus |
| `onTokenRefresh` diteruskan ke callback backend | Lulus |
| Foreground memakai local notification manual | Lulus |
| Foreground/background/terminated memetakan `data.route` | Lulus secara kode; perlu bukti perangkat untuk FCM |
| Token/secret tidak di-hardcode atau dicetak penuh | Lulus |

Firebase sengaja tidak diinisialisasi otomatis pada demo agar `flutter test` dan login mock dapat berjalan tanpa file kredensial. Setelah `Firebase.initializeApp()` dan konfigurasi native ditambahkan, `PushService.initialize` siap dipakai.
