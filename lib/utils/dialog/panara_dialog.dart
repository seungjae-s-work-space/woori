import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:woori/utils/localization_extension.dart';

void showSuccessDialog(BuildContext context, String message) {
  PanaraInfoDialog.show(
    context,
    title: context.l10n.dialog_text_success,
    message: message,
    buttonText: context.l10n.dialog_okay_button,
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.normal,
    barrierDismissible: false,
  );
}

void showErrorDialog(BuildContext context, String message) {
  PanaraInfoDialog.show(
    context,
    title: context.l10n.dialog_text_error,
    message: message,
    buttonText: context.l10n.dialog_okay_button,
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
