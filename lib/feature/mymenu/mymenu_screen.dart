import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/dto/invite_dto.dart';
import 'package:woori/feature/mymenu/provider/invite_provider.dart';
import 'package:woori/utils/localization_extension.dart';

class MyMenuScreen extends ConsumerStatefulWidget {
  const MyMenuScreen({super.key});

  @override
  ConsumerState<MyMenuScreen> createState() => _MyMenuScreenState();
}

class _MyMenuScreenState extends ConsumerState<MyMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await ref.read(inviteProvider.notifier).loadInvitesFromMe();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invitesAsync = ref.watch(inviteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mymenu_screen_title),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n.mymenu_tab_invited_by_me),
            Tab(text: context.l10n.mymenu_tab_invited_me),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInvitedByMeTab(invitesAsync),
          _buildInvitedMeTab(invitesAsync),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(inviteProvider.notifier).createInviteLink(),
        child: const Icon(Icons.share),
      ),
    );
  }

  Widget _buildInvitedByMeTab(AsyncValue<InviteListResponseDto> invitesAsync) {
    return invitesAsync.when(
      data: (data) {
        if (data.invites.isEmpty) {
          return Center(
            child: Text(context.l10n.mymenu_empty_invited_by_me),
          );
        }
        return ListView.builder(
          itemCount: data.invites.length,
          itemBuilder: (context, index) {
            final invite = data.invites[index];
            return ListTile(
              title: Text(invite.toUser.nickname),
              subtitle: Text(invite.toUser.email),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmDialog(invite.id),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(context.l10n.mymenu_error_message),
      ),
    );
  }

  Widget _buildInvitedMeTab(AsyncValue<InviteListResponseDto> invitesAsync) {
    return invitesAsync.when(
      data: (data) {
        if (data.invites.isEmpty) {
          return Center(
            child: Text(context.l10n.mymenu_empty_invited_me),
          );
        }
        return ListView.builder(
          itemCount: data.invites.length,
          itemBuilder: (context, index) {
            final invite = data.invites[index];
            return ListTile(
              title: Text(invite.fromUser.nickname),
              subtitle: Text(invite.fromUser.email),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(context.l10n.mymenu_error_message),
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(String inviteId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.mymenu_delete_confirm_title),
        content: Text(context.l10n.mymenu_delete_confirm_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.mymenu_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.mymenu_delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(inviteProvider.notifier).deleteInvite(inviteId);
    }
  }
}
