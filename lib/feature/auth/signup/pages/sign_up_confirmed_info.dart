import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/auth/login/login_screen.dart';
import 'package:woori/feature/auth/signup/provider/sign_up_provider.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/dialog/panara_dialog.dart';
import 'package:woori/utils/interceptor/error_code_extension.dart';
import 'package:woori/utils/localization_extension.dart';

class SignUpConfirmedInfo extends ConsumerWidget {
  final VoidCallback onNext;
  const SignUpConfirmedInfo({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpData = ref.watch(signUpProvider);
    final signUpState = ref.read(signUpProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getHorizontalPadding(context),
        vertical: AppTheme.getVerticalPadding(context),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Text(signUpData.signUpDto?.email ?? ''),
            Text(signUpData.signUpDto?.nickname ?? ''),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await signUpState.signUp(signUpData.signUpDto!);

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInScreen(),
                        ),
                      );
                    }
                  } on DioException catch (e) {
                    if (context.mounted) {
                      showErrorDialog(context, e.getErrorMessage(context));
                    }
                  }
                },
                child: Text(context.l10n.button_text_sign_up)),
          ],
        ),
      ),
    );
  }
}
