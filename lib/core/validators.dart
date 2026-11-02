class NestValidators {
  static String? email(String? input) {
    final value = input?.trim() ?? '';
    if (value.isEmpty) return 'Введите email';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return 'Введите корректный email, например hello@example.com';
    }
    return null;
  }

  static String? password(String? input) {
    if (input == null || input.isEmpty) return 'Введите пароль';
    if (input.length < 6) return 'Пароль должен содержать минимум 6 символов';
    return null;
  }

  static String? requiredText(String? input, {String name = 'Это поле'}) {
    if (input == null || input.trim().isEmpty) return 'Это поле обязательно';
    return null;
  }
}
