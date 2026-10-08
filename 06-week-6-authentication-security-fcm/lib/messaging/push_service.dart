import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _local = FlutterLocalNotificationsPlugin();
String? pendingDeepLink;

String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route']?.toString() ?? '/';
  if (route.isEmpty || route == '/') return '/';
  return route.startsWith('/') ? route : '/$route';
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class PushService {
  Future<void> initialize({
    required Future<void> Function(String token) onToken,
    required void Function(String route) onRoute,
  }) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await requestNotificationPermission();
    await initLocalNotifications(onRoute);
    await initFcmToken(onToken: onToken);
    listenForeground(onRoute);
    await handleTerminated(onRoute);
  }

  Future<bool> requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> initLocalNotifications(void Function(String route) onRoute) async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null) onRoute(routeFromMessage({'route': route}));
      },
    );
  }

  Future<void> initFcmToken({
    required Future<void> Function(String token) onToken,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await onToken(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(onToken);
    await FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');
  }

  void listenForeground(void Function(String route) onRoute) {
    FirebaseMessaging.onMessage.listen((message) async {
      const details = AndroidNotificationDetails(
        'pengumuman',
        'Pengumuman Kampus',
        importance: Importance.high,
        priority: Priority.high,
      );
      await _local.show(
        message.hashCode,
        message.notification?.title ?? 'Pengumuman',
        message.notification?.body ?? '',
        const NotificationDetails(android: details),
        payload: routeFromMessage(message.data),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => onRoute(routeFromMessage(message.data)),
    );
  }

  Future<void> handleTerminated(void Function(String route) onRoute) async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) onRoute(routeFromMessage(initial.data));
    if (pendingDeepLink != null) onRoute(pendingDeepLink!);
  }

  Future<void> subscribeToCampusTopic() =>
      FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');

  Future<void> unsubscribeFromCampusTopic() =>
      FirebaseMessaging.instance.unsubscribeFromTopic('pengumuman-kampus');
}
