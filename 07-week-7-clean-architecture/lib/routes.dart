import 'package:flutter/foundation.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcement = '/pengumuman/:id';

  static String announcementFor(String id) => '/pengumuman/$id';
}

final routerRefresh = ValueNotifier<int>(0);
