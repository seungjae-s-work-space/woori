import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/common/provider/user/user_profile_provider.dart';
import 'package:woori/utils/app_theme.dart';
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
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('로그인이 만료되었습니다. 다시 로그인해주세요.'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.getHorizontalPadding(context),
            vertical: AppTheme.spacing32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: AppTheme.spacing48),

              // 로고 섹션
              Column(
                children: [
                  Assets.images.dash.appLogo.image(width: 200),
                  const SizedBox(height: AppTheme.spacing32),
                  Assets.images.dash.appLogoCharacter.image(width: 143),
                ],
              ),

              // 버튼 섹션
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primarySky,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing16,
                        ),
                      ),
                      child: Text(
                        context.l10n.button_text_login,
                        style: AppTheme.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
