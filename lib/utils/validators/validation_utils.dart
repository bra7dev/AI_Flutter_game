import 'regex_validator.dart';

class ValidationUtils {
  /// Form validation for email address field.
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    } else if (RegexValidator.validateEmail(email) == false) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateUserName(String? userName) {
    if (userName == null || userName.isEmpty) {
      return 'Full name is required';
    } else if (userName.length < 3) {
      return 'Must be atleast 3 characters long';
    }
    return null;
  }

  static String? validateEmptyField(String? input) {
    if (input == null || input.isEmpty) {
      return 'Field is required';
    } else if (input.length < 3) {
      return 'Must be atleast 3 characters long';
    }
    return null;
  }

  static String? validateCnic(String? cnic) {
    if (cnic == null || cnic.isEmpty) {
      return 'Cnic is required';
    } else if (cnic.length != 13) {
      return 'Must be at-least 13 characters long';
    }
    return null;
  }

  /// Form validation for password  field.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    } else if (password.length < 8) {
      return 'Password must be 8 characters long';
    }
    return null;
  }

  /// Form validation for confirm password field.
  static String? validateConfirmPassword(
      String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Password is required';
    } else if (confirmPassword != password) {
      return 'Password must be same';
    }
    return null;
  }

  static String? validatePhoneNumber(String? number) {
    if (number == null || number.isEmpty) {
      return 'Phone no is required';
    }
    return null;
  }
}
