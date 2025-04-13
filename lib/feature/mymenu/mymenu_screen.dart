import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/mymenu/provider/invite_provider.dart';
import 'package:woori/utils/localization_extension.dart';
import 'package:woori/common/provider/user/user_profile_provider.dart';
import 'package:go_router/go_router.dart';

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
        title: Text(context.l10n.mymenu_invite_code_title),
        content: TextField(
          controller: _codeController,
          decoration: InputDecoration(
            hintText: context.l10n.mymenu_invite_code_hint,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.mymenu_cancel),
          ),
          TextButton(
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
                          content:
                              Text(context.l10n.mymenu_invite_code_success)),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(context.l10n.mymenu_invite_code_error)),
                    );
                  }
                }
              }
            },
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 내 정보 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userProfileState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (userProfileState.error != null)
                      const SizedBox.shrink()
                    else if (userProfileState.userModel != null)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              userProfileState.userModel!.nickname[0]
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProfileState.userModel!.nickname,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  userProfileState.userModel!.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              context.go('/login');
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Divider(),

              // 초대 코드 입력 버튼
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _showInviteCodeDialog,
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.mymenu_enter_invite_code),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
              const Divider(),

              // 내가 초대한 사람 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.mymenu_tab_invited_by_me,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: fromMeAsync.when(
                        data: (data) {
                          if (data.invites.isEmpty) {
                            return Center(
                              child: Text(
                                context.l10n.mymenu_empty_invited_by_me,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.invites.length,
                            itemBuilder: (context, index) {
                              final invite = data.invites[index];
                              return Card(
                                margin: const EdgeInsets.only(right: 8),
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        child: Text(
                                          invite.toUser.nickname[0]
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        invite.toUser.nickname,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (_, __) => Center(
                          child: Text(
                            context.l10n.mymenu_error_message,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // 나를 초대한 사람 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.mymenu_tab_invited_me,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: toMeAsync.when(
                        data: (data) {
                          if (data.invites.isEmpty) {
                            return Center(
                              child: Text(
                                context.l10n.mymenu_empty_invited_me,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.invites.length,
                            itemBuilder: (context, index) {
                              final invite = data.invites[index];
                              return Card(
                                margin: const EdgeInsets.only(right: 8),
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        child: Text(
                                          invite.fromUser.nickname[0]
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        invite.fromUser.nickname,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (_, __) => Center(
                          child: Text(
                            context.l10n.mymenu_error_message,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(invitesFromMeProvider.notifier).createInviteCode(),
        child: const Icon(Icons.share),
      ),
    );
  }
}
