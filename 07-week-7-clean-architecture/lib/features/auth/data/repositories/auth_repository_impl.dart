import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    if (!email.contains('@') || password.length < 6) {
      return (
        session: null,
        failure: const AuthFailure('Email atau kata sandi tidak valid.'),
      );
    }
    final model = AuthSessionModel(
      access: 'mock-access-for-$email',
      refresh: 'mock-refresh-for-$email',
    );
    await _storage.write(key: _accessKey, value: model.access);
    await _storage.write(key: _refreshKey, value: model.refresh);
    return (session: model.toEntity(), failure: null);
  }

  @override
  Future<bool> hasSession() async =>
      (await _storage.read(key: _accessKey)) != null;

  @override
  Future<void> logout() => _storage.deleteAll();
}
