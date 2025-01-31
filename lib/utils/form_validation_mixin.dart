import 'package:woori/utils/localization_extension.dart';
import 'package:woori/utils/regex_patterns.dart';
import 'package:flutter/widgets.dart';

mixin FormValidationMixin {
  String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.form_validation_email_required;
    }

    if (!RegexPatterns.email.hasMatch(value)) {
      return context.l10n.form_validation_email_invalid;
    }
    return null;
  }

  String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.form_validation_password_required;
    }
    if (value.length < 4) {
      return context.l10n.form_validation_password_short;
    }
    return null;
  }
}
