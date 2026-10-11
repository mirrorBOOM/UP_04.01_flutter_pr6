class AppValidators {
  static String? requiredField(
    String? value, [
    String message = 'Обязательное поле',
  ]) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.trim().length < min) {
      return 'Минимум $min символов';
    }
    return null;
  }

  static String? positiveInt(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите число';
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) return 'Число должно быть больше 0';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите email';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'Некорректный формат почты';
    return null;
  }
}
