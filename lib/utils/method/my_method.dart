class MyMethod {
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name can not be empty!';
    }

    RegExp namePattern = RegExp(r'^[a-zA-ZÀ-ỹ\s0-9]+$', unicode: true);
    if (!namePattern.hasMatch(name)) {
      return 'Name must not contains special character!';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Password can not be empty!';
    }

    if (password.length < 5) {
      return 'Password must more than 4 characters!';
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    return (password != null) &&
            (confirmPassword != null) &&
            (password.isNotEmpty) &&
            (confirmPassword.isNotEmpty) &&
            (password == confirmPassword)
        ? null
        : 'Confirm and password not same!';
  }

  static bool isTokenHasExpired(Map<String, dynamic> map){
    if (map.containsKey('error')){
      String errValue = map['error'];
      if (errValue.contains('Token has expired')){
        return true;
      }
    }
    return false;
  }
}
