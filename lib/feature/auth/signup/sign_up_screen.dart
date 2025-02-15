import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/auth/signup/pages/sign_up_confirmed_info.dart';
import 'package:woori/feature/auth/signup/pages/sign_up_input_nickname_page.dart';
import 'package:woori/feature/auth/signup/pages/sing_up_input_user_id_pw_page.dart';
import 'package:woori/utils/localization_extension.dart';

/*
  페이지뷰로 구성한 이유는 추후 회원가입 시 개인정보 처리 방침 동의를 위한 페이지가 추가되며,
  구성단계에서 추가 기능이 존재할 수 있기 때문에 우선 페이지뷰로 구현 하였습니다
*/

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    userEmailController.dispose();
    pwController.dispose();
    pwConfirmController.dispose();
    nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sign_up_app_bar_title),
        leading: IconButton(
            onPressed: () {
              if (_pageController.page == 0) {
                Navigator.pop(context);
              } else {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          SingUpInputUserIdPwPage(
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            userEmailController: userEmailController,
            pwController: pwController,
            pwConfirmController: pwConfirmController,
            formKey: formKey,
          ),
          SignUpInputNickNamePage(
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            nickNameController: nickNameController,
          ),
          SignUpConfirmedInfo(
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
