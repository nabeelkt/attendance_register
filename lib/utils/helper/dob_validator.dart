class DateOfBirthValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a date of birth';
    }
    final dateRegex =
        RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Please enter a valid date of birth in the format DD-MM-YYYY';
    }
    return null;
  }
}
