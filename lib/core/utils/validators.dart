class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  static String? validateRepeatPassword(
    String? password,
    String? repeatPassword,
  ) {
    if (repeatPassword == null || repeatPassword.isEmpty) {
      return 'Please repeat your password';
    }

    if (password != repeatPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
