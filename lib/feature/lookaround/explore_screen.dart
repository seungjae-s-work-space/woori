import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/lookaround/provider/explore_provider.dart';
import 'package:woori/utils/localization_extension.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(explorePostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.explore_screen_title),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(explorePostsProvider.notifier).loadPosts(refresh: true),
        child: postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return Center(
                child: Text(context.l10n.explore_screen_empty_message),
              );
            }

            return ListView.builder(
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == posts.length) {
                  return SizedBox();
                }
                final post = posts[index];
                return ListTile(
                  title: Text(post.content),
                  subtitle: Text(
                    context.l10n
                        .explore_screen_post_author(post.user?.nickname ?? ''),
                  ),
                  trailing: Text(
                    _formatDate(post.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(context.l10n.explore_screen_error_message),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
