import 'package:insta_chat/utils/app_string.dart';

class MyValidators {
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return AppString.emptyName;
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return AppString.nameCharacters;
    }

    return null; // Return null if display name is valid
  }

  static String? phoneValidator(String? phone) {
    if (phone == null || phone.isEmpty) {
      return AppString.emptyNumber;
    }
    if (phone.length != 11) {
      return AppString.egyptianNumber;
    }

    return null; // Return null if phone is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return AppString.emailHint;
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return AppString.emailValid;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return AppString.passwordHint;
    }
    if (value.length < 6) {
      return AppString.passwordCharacters;
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return AppString.passwordNoMatch;
    }
    return null;
  }
}
