import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                controller: emailController,
                validator: (value) => validateEmail(value, context),
                decoration: const InputDecoration(
                  labelText: '이메일',
                ),
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) => validatePassword(value, context),
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                ),
              ),
              TextButton(
                  onPressed: () {
                    //TODO 원활한 더미 스크린 이동을 위해 잠시 주석처리 함 추후 기능 구현 시 주석 제거 할 것
                    // if (_formKey.currentState?.validate() ?? false) {
                    //   showDialog(
                    //       context: context,
                    //       builder: (context) => const RoleDialogWidget());
                    // }
                    context.push('/select_role');
                  },
                  child: const Text("로그인")),
              TextButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  child: const Text("Sign up"))
            ],
          ),
        ),
      ),
    );
  }
}
