import 'package:flutter/material.dart';
import 'package:woori/feature/auth/login/widget/log_in_button_widget.dart';
import 'package:woori/feature/auth/login/widget/sign_up_button_widget.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/form_validation_mixin.dart';
import 'package:woori/utils/localization_extension.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> with FormValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nicknameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.login_app_bar_title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.getHorizontalPadding(context),
          vertical: AppTheme.getVerticalPadding(context),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nicknameController,
                // validator: (value) => validateEmail(value, context),
                decoration: const InputDecoration(
                  labelText: '닉네임',
                ),
                // keyboardType:
                //     TextInputType.emailAddress, // 이메일 입력을 위한 입력 키보드로 변환
                textInputAction:
                    TextInputAction.next, // 스크린의 입력 키보드에 next 버튼 생성
              ),
              TextFormField(
                controller: passwordController,
                // validator: (value) => validatePassword(value, context),
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                ),
                onFieldSubmitted: (_) {
                  LogInButton(
                    formKey: _formKey,
                    nicknameController: nicknameController,
                    passwordController: passwordController,
                  );
                },
              ),
              // const FindPwButton(),
              LogInButton(
                formKey: _formKey,
                nicknameController: nicknameController,
                passwordController: passwordController,
              ),

              /// 로그인 폼 - 로그인 버튼
              const SizedBox(height: 10),
              const SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}
