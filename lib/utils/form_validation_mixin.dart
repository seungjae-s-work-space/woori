import 'package:flutter/widgets.dart';
import 'package:woori/utils/localization_extension.dart';
import 'package:woori/utils/regex_patterns.dart';

mixin FormValidationMixin {
  String? validateEmail(String? email, BuildContext context) {
    if (email == null || email.isEmpty) {
      return context.l10n.form_validation_any_required;
    }

    if (!RegexPatterns.email.hasMatch(email)) {
      return context.l10n.form_validation_email_invalid;
    }
    return null;
  }

  String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      return context.l10n.form_validation_any_required;
    }
    if (password.length < 4) {
      return context.l10n.form_validation_password_short;
    }
    return null;
  }

  String? validatePasswordConfirm(
      String? password, String? passwordConfirm, BuildContext context) {
    if (passwordConfirm == null || passwordConfirm.isEmpty) {
      return context.l10n.form_validation_any_required;
    }
    if (password != passwordConfirm) {
      return context.l10n.form_validation_password_confirm_not_match;
    }
    return null;
  }

  String? validateNameLimit2To20(String? name, BuildContext context) {
    if (name == null || name.isEmpty) {
      return context.l10n.form_validation_any_required;
    }
    if (name.length < 2) {
      return context.l10n.form_validation_restaurant_name_short;
    }
    if (name.length > 20) {
      return context.l10n.form_validation_restaurant_name_long;
    }
    return null;
  }

  // String? validateRestaurantCategory(
  //     RestaurantCategoryEnum? restaurantCategory, BuildContext context) {
  //   if (restaurantCategory == null) {
  //     return context.l10n.form_validation_any_required;
  //   }
  //   return null;
  // }

  String? validateInteger(String? integer, BuildContext context) {
    if (integer == null || integer.isEmpty) {
      return context.l10n.form_validation_any_required;
    }
    if (int.tryParse(integer) == null) {
      return context.l10n.form_validation_input_number;
    }
    return null;
  }
}
