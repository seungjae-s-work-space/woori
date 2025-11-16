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
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: Text(context.l10n.login_app_bar_title),
        centerTitle: false,
        backgroundColor: AppTheme.backgroundGray,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.getHorizontalPadding(context),
            vertical: AppTheme.spacing24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.spacing48),

                // 타이틀
                Text(
                  '환영합니다',
                  style: AppTheme.heading1.copyWith(
                    fontSize: 28,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  '계속하려면 로그인하세요',
                  style: AppTheme.body1.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: AppTheme.spacing48),

                // 입력 폼 카드
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      // 닉네임 입력
                      TextFormField(
                        controller: nicknameController,
                        decoration: const InputDecoration(
                          labelText: '닉네임',
                          hintText: '닉네임을 입력하세요',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: AppTheme.spacing20),

                      // 비밀번호 입력
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          hintText: '비밀번호를 입력하세요',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        onFieldSubmitted: (_) {
                          if (_formKey.currentState?.validate() ?? false) {
                            // 로그인 실행
                          }
                        },
                      ),

                      const SizedBox(height: AppTheme.spacing32),

                      // 로그인 버튼
                      LogInButton(
                        formKey: _formKey,
                        nicknameController: nicknameController,
                        passwordController: passwordController,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacing24),

                // 회원가입 버튼
                const SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
