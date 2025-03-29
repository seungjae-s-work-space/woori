import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/meal_log/provider/meal_log_provider.dart';
import 'package:woori/utils/localization_extension.dart';

class MealLogScreen extends ConsumerWidget {
  const MealLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(mealLogPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.meal_log_screen_title),
      ),
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
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.content),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.imageUrl != null)
                        Image.network(
                          post.imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Text(
                        context.l10n.meal_log_screen_post_date(
                          _formatDate(post.createdAt),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(context.l10n.meal_log_screen_error_message),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
