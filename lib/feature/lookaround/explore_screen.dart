import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/lookaround/provider/explore_provider.dart';
import 'package:woori/feature/lookaround/widget/post_card.dart';
import 'package:woori/utils/appbar/app_bar.dart';
import 'package:woori/utils/localization_extension.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(explorePostsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBarContent(context, 1, context.l10n.look_around),
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

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // 스크롤이 끝에 도달했을 때 더 불러오기
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  ref.read(explorePostsProvider.notifier).loadPosts();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return const SizedBox(height: 16);
                  }
                  final post = posts[index];
                  return PostCard(
                    post: post,
                    onRefresh: () => ref
                        .read(explorePostsProvider.notifier)
                        .loadPosts(refresh: true),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.l10n.explore_screen_error_message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(explorePostsProvider.notifier)
                      .loadPosts(refresh: true),
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
