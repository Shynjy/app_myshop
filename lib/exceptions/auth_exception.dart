class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'O e-mail já está sendo utilizado!',
    'OPERATION_NOT_ALLOWED': 'Senha inválido!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Muitas tentativas repeditas, tente mais tarte!',
    'EMAIL_NOT_FOUND': 'E-mail não cadastrado ou senha inválida!',
    'INVALID_PASSWORD': 'E-mail não cadastrado ou senha inválida!',
    'USER_DISABLED': 'Sua conta foi desabilitada!',
    'WEAK_PASSWORD : Password should be at least 6 characters': 'A senha deve conter mais de 5 caracteres!',
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro, tente mais tarde!';
    }
  }
}
