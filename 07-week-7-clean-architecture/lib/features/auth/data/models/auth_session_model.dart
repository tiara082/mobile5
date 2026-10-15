import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.access, required super.refresh});

  AuthSession toEntity() => AuthSession(access: access, refresh: refresh);
}
