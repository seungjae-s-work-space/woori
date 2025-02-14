import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/dto/sign_up_dto.dart';
import 'package:woori/feature/auth/signup/provider/sign_up_provider.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/form_validation_mixin.dart';
import 'package:woori/utils/localization_extension.dart';

class SingUpInputUserIdPwPage extends ConsumerWidget with FormValidationMixin {
  final VoidCallback onNext;
  final TextEditingController userEmailController;
  final TextEditingController pwController;
  final TextEditingController pwConfirmController;
  final GlobalKey<FormState> formKey;
  SingUpInputUserIdPwPage({
    super.key,
    required this.onNext,
    required this.userEmailController,
    required this.pwController,
    required this.pwConfirmController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref
        .read(signUpProvider.notifier); //뒤에 .notifier까지 붙여야 노티파이어를 호출하는 인스턴스임.
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getHorizontalPadding(context),
        vertical: AppTheme.getVerticalPadding(context),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: userEmailController,
                  validator: (email) => validateEmail(email, context),
                  decoration: InputDecoration(
                    labelText: context.l10n.form_label_text_email,
                  ),
                ),
                TextFormField(
                  controller: pwController,
                  validator: (pw) => validatePassword(pw, context),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: context.l10n.form_label_text_password,
                  ),
                ),
                TextFormField(
                  controller: pwConfirmController,
                  validator: (pwConfirm) => validatePasswordConfirm(
                      pwController.text, pwConfirm, context),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: context.l10n.form_label_text_password_confirm,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      signUpState.updateDto(SignUpDto(
                        email: userEmailController.text,
                        password: pwController.text,
                      ));
                      onNext();
                    }
                  },
                  child: Text(context.l10n.button_text_next),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
