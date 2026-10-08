import 'package:dio/dio.dart';

import 'auth_repository.dart';
import 'token_store.dart';

Dio buildApiClient(TokenStore store, AuthRepository auth) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://example-campus-api.test',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await store.readAccess();
        if (access != null) options.headers['Authorization'] = 'Bearer $access';
        handler.next(options);
      },
      onError: (error, handler) async {
        final retried = error.requestOptions.extra['retried'] == true;
        if (error.response?.statusCode != 401 || retried) {
          handler.next(error);
          return;
        }
        final refresh = await store.readRefresh();
        if (refresh == null || refresh.isEmpty) {
          await store.clear();
          handler.next(error);
          return;
        }
        try {
          final renewed = await auth.refresh(refresh);
          await store.save(access: renewed, refresh: refresh);
          final request = error.requestOptions
            ..extra['retried'] = true
            ..headers['Authorization'] = 'Bearer $renewed';
          handler.resolve(await dio.fetch(request));
        } on Object {
          await store.clear();
          handler.next(error);
        }
      },
    ),
  );
  return dio;
}
