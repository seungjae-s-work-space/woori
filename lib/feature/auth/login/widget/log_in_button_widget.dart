import 'package:go_router/go_router.dart';
import 'package:woori/common/provider/user/user_profile_provider.dart';
import 'package:woori/dto/login_dto.dart';
import 'package:woori/feature/auth/login/provider/login_provider.dart';
import 'package:woori/utils/dialog/panara_dialog.dart';
import 'package:woori/utils/interceptor/error_code_extension.dart';
import 'package:woori/utils/localization_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인 버튼 위젯
class LogInButton extends ConsumerWidget {
  /// LogInButton 생성자
  const LogInButton({
    required this.formKey,
    required this.nicknameController,
    required this.passwordController,
    super.key,
  });

  /// 로그인 폼 키
  final GlobalKey<FormState> formKey;

  /// 이메일 컨트롤러
  /// 하위에서 사용한 이유는 상위 스크린에서 컨트롤러를 부르고 한번에 dispose 할 수 있도록 하기 위함입니다.
  final TextEditingController nicknameController;

  /// 비밀번호 컨트롤러
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.watch(loginProvider.notifier);
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            try {
              /// 먼저 LoginDto 생성
              final loginDto = LoginDto(
                nickname: nicknameController.text,
                password: passwordController.text,
              );

              /// 상태 업데이트
              loginNotifier.updateLogInDto(loginDto);
              await loginNotifier.login();

              /// 같은 loginDto 인스턴스 사용
              // await loginNotifier.getRestaurantTableInfo(loginDto);

              if (context.mounted) {
                print('good');
                await ref.read(userProfileProvider.notifier).getUser();
                await context.push('/camera');
              }
            } on DioException catch (e) {
              if (context.mounted) {
                showErrorDialog(context, e.getErrorMessage(context));
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          context.l10n.button_text_login,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
