class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ادخل الاسم';
    }
    if (value.trim().length < 2) {
      return 'الاسم يجب أن يحتوي على حرفين على الأقل';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? childName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ادخل اسم الطفل';
    }
    return null;
  }
}
