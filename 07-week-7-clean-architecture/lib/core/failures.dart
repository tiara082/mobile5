sealed class Failure {
  const Failure(this.message);

  final String message;
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
