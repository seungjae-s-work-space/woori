import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/feature/meal_log/provider/meal_log_provider.dart';
import 'package:woori/feature/meal_log/widget/my_post_card.dart';
import 'package:woori/utils/appbar/app_bar.dart';
import 'package:woori/utils/localization_extension.dart';

class MealLogScreen extends ConsumerWidget {
  const MealLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(mealLogPostsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBarContent(context, 1, context.l10n.meal_log, index: 0),
      body: RefreshIndicator(
        onRefresh: () => ref.read(mealLogPostsProvider.notifier).loadPosts(),
        child: postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return Center(
                child: Text(context.l10n.meal_log_screen_empty_message),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return MyPostCard(
                  post: post,
                  onRefresh: () =>
                      ref.read(mealLogPostsProvider.notifier).loadPosts(),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.l10n.meal_log_screen_error_message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(mealLogPostsProvider.notifier).loadPosts(),
                  child: Text(context.l10n.retry_button),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
