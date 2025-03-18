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
