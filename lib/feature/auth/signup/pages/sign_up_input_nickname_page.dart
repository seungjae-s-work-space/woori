import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/dto/sign_up_dto.dart';
import 'package:woori/feature/auth/signup/provider/sign_up_provider.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/form_validation_mixin.dart';
import 'package:woori/utils/localization_extension.dart';

class SignUpInputNickNamePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final TextEditingController nickNameController;
  const SignUpInputNickNamePage({
    super.key,
    required this.onNext,
    required this.nickNameController,
  });

  @override
  ConsumerState<SignUpInputNickNamePage> createState() =>
      _SignUpInputRestaurantInfoPageState();
}

class _SignUpInputRestaurantInfoPageState
    extends ConsumerState<SignUpInputNickNamePage> with FormValidationMixin {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.read(signUpProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getHorizontalPadding(context),
        vertical: AppTheme.getVerticalPadding(context),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: widget.nickNameController,
                validator: (name) => validateNameLimit2To20(name, context),
                decoration: InputDecoration(
                  labelText: context.l10n.form_label_text_restaurant_name,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    /* 여기에서 앞에 입력받은 email, password를 가져온 이유는
                      flutter pageView의 특성 상 이전 page가 dispose될때 provider의
                      data도 같이 사라집니다. 유효값의 시간이 2페이지정도 유지됩니다.
                      즉 3번째 confirmed로 이동하게 되면 1번째 page의 데이터는 dispose처리 됩니다.
                      그래서 이전 페이지에서 입력받은 데이터를 다시한번 updatae로 넣어줘야합니다.
                      물론 keepPage: true로 설정하면 dispose되지 않지만
                      회원가입 플로우는 일회성이므로 불필요한 메모리 사용을 피하고 싶습니다.
                    */
                    final currentSignUpDto = ref.read(signUpProvider).signUpDto;
                    signUpState.updateDto(SignUpDto(
                      email: currentSignUpDto?.email,
                      password: currentSignUpDto?.password,
                      nickname: widget.nickNameController.text,
                    ));
                    widget.onNext();
                  }
                },
                child: Text(context.l10n.button_text_next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
