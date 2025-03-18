import 'package:woori/utils/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 회원가입 페이지로 이동하는 버튼 위젯
class SignUpButton extends StatelessWidget {
  /// SignUpButton 생성자
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.push('/sign-up');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          context.l10n.button_text_sign_up,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
