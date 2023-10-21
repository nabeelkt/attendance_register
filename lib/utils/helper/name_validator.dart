class FirstNameValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter first name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }
}

class LastNameValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter last name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }
}
