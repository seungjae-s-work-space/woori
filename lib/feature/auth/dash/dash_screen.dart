import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/common/provider/user/user_profile_provider.dart';
import 'package:woori/utils/image_generated/assets.gen.dart';
import 'package:woori/utils/localization_extension.dart';

class DashScreen extends ConsumerWidget {
  const DashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProfileProvider, (previous, next) {
      if (next.userModel != null) {
        context.go('/camera');
      } else if (next.error == 'TOKEN_EXPIRED') {
        // 토큰 만료시 로그인 페이지로 이동
        context.go('/login');
        // 선택적: 토스트 메시지나 스낵바로 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 만료되었습니다. 다시 로그인해주세요.'),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Assets.images.dash.appLogo.image(width: 200),
            Assets.images.dash.appLogoCharacter.image(width: 143),
            Center(
                child: GestureDetector(
              onTap: () {
                context.push('/login');
              },
              child: Container(
                  decoration: const BoxDecoration(color: Color(0xff545454)),
                  child: Text(
                    context.l10n.button_text_login,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
