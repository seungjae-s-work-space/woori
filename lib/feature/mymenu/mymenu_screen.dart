import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/mymenu/provider/invite_provider.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/appbar/app_bar.dart';
import 'package:woori/utils/localization_extension.dart';
import 'package:woori/common/provider/user/user_profile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/feature/auth/logout/provider/logout_provider.dart';

class MyMenuScreen extends ConsumerStatefulWidget {
  const MyMenuScreen({super.key});

  @override
  ConsumerState<MyMenuScreen> createState() => _MyMenuScreenState();
}

class _MyMenuScreenState extends ConsumerState<MyMenuScreen> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = ref.read(userProfileProvider);
      if (userState.userModel == null &&
          !userState.isLoading &&
          userState.error == null) {
        ref.read(userProfileProvider.notifier).getUser();
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _showInviteCodeDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          context.l10n.mymenu_invite_code_title,
          style: AppTheme.heading2.copyWith(
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.mymenu_invite_code_hint,
              style: AppTheme.body2.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'ABC123',
                filled: true,
                fillColor: AppTheme.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: const BorderSide(color: AppTheme.primarySky, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                  vertical: AppTheme.spacing16,
                ),
              ),
              textCapitalization: TextCapitalization.characters,
              style: AppTheme.body1.copyWith(
                fontSize: 16,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing20,
                vertical: AppTheme.spacing12,
              ),
            ),
            child: Text(context.l10n.mymenu_cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_codeController.text.isNotEmpty) {
                try {
                  await ref
                      .read(invitesToMeProvider.notifier)
                      .acceptInviteCode(_codeController.text);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.mymenu_invite_code_success),
                        backgroundColor: AppTheme.accentGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.mymenu_invite_code_error),
                        backgroundColor: AppTheme.accentRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primarySky,
              foregroundColor: AppTheme.backgroundWhite,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing20,
                vertical: AppTheme.spacing12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Text(context.l10n.mymenu_accept),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileProvider);
    final fromMeAsync = ref.watch(invitesFromMeProvider);
    final toMeAsync = ref.watch(invitesToMeProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: buildAppBarContent(context, 1, context.l10n.my_menu),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacing16),

              // 내 정보 섹션
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                ),
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
                child: userProfileState.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppTheme.spacing24),
                          child: CircularProgressIndicator(
                            color: AppTheme.primarySky,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : userProfileState.error != null
                        ? const SizedBox.shrink()
                        : userProfileState.userModel != null
                            ? Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: AppTheme.primarySkyLight,
                                    foregroundColor: AppTheme.primarySkyDark,
                                    child: Text(
                                      userProfileState.userModel!.nickname[0]
                                          .toUpperCase(),
                                      style: AppTheme.heading1.copyWith(
                                        color: AppTheme.primarySkyDark,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacing16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userProfileState.userModel!.nickname,
                                          style: AppTheme.heading2.copyWith(
                                            fontSize: 18,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          userProfileState.userModel!.email,
                                          style: AppTheme.body2.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.backgroundLight,
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusSmall),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.logout,
                                        color: AppTheme.textSecondary,
                                      ),
                                      onPressed: () async {
                                        await ref
                                            .read(logoutProvider.notifier)
                                            .logout();
                                        if (mounted) context.go('/dash');
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
              ),

              const SizedBox(height: AppTheme.spacing16),

              // 초대 코드 입력 버튼
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showInviteCodeDialog,
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.mymenu_enter_invite_code),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primarySky,
                      side: const BorderSide(color: AppTheme.primarySky),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacing24),

              // 내가 초대한 사람 섹션
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.mymenu_tab_invited_by_me,
                      style: AppTheme.heading2.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    SizedBox(
                      height: 110,
                      child: fromMeAsync.when(
                        data: (data) {
                          if (data.invites.isEmpty) {
                            return Center(
                              child: Text(
                                context.l10n.mymenu_empty_invited_by_me,
                                style: AppTheme.body2.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.invites.length,
                            itemBuilder: (context, index) {
                              final invite = data.invites[index];
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(
                                  right: AppTheme.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundWhite,
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusMedium),
                                  border: Border.all(
                                    color: AppTheme.border,
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(
                                    AppTheme.spacing12),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor:
                                          AppTheme.primarySkyLight,
                                      foregroundColor:
                                          AppTheme.primarySkyDark,
                                      child: Text(
                                        invite.toUser.nickname[0]
                                            .toUpperCase(),
                                        style: AppTheme.heading2.copyWith(
                                          fontSize: 18,
                                          color: AppTheme.primarySkyDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spacing8),
                                    Text(
                                      invite.toUser.nickname,
                                      style: AppTheme.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primarySky,
                            strokeWidth: 3,
                          ),
                        ),
                        error: (_, __) => Center(
                          child: Text(
                            context.l10n.mymenu_error_message,
                            style: AppTheme.body2.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacing24),

              // 나를 초대한 사람 섹션
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.mymenu_tab_invited_me,
                      style: AppTheme.heading2.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    SizedBox(
                      height: 110,
                      child: toMeAsync.when(
                        data: (data) {
                          if (data.invites.isEmpty) {
                            return Center(
                              child: Text(
                                context.l10n.mymenu_empty_invited_me,
                                style: AppTheme.body2.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.invites.length,
                            itemBuilder: (context, index) {
                              final invite = data.invites[index];
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(
                                  right: AppTheme.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundWhite,
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusMedium),
                                  border: Border.all(
                                    color: AppTheme.border,
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(
                                    AppTheme.spacing12),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor:
                                          AppTheme.primarySkyLight,
                                      foregroundColor:
                                          AppTheme.primarySkyDark,
                                      child: Text(
                                        invite.fromUser.nickname[0]
                                            .toUpperCase(),
                                        style: AppTheme.heading2.copyWith(
                                          fontSize: 18,
                                          color: AppTheme.primarySkyDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spacing8),
                                    Text(
                                      invite.fromUser.nickname,
                                      style: AppTheme.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primarySky,
                            strokeWidth: 3,
                          ),
                        ),
                        error: (_, __) => Center(
                          child: Text(
                            context.l10n.mymenu_error_message,
                            style: AppTheme.body2.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacing24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(invitesFromMeProvider.notifier).createInviteCode(),
        backgroundColor: AppTheme.primarySky,
        foregroundColor: AppTheme.backgroundWhite,
        child: const Icon(Icons.share),
      ),
    );
  }
}
