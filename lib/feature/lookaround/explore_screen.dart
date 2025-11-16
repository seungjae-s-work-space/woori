import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/lookaround/provider/explore_provider.dart';
import 'package:woori/feature/lookaround/widget/post_card.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/appbar/app_bar.dart';
import 'package:woori/utils/localization_extension.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(explorePostsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: buildAppBarContent(context, 1, context.l10n.look_around),
      body: RefreshIndicator(
        color: AppTheme.primarySky,
        backgroundColor: AppTheme.backgroundWhite,
        onRefresh: () =>
            ref.read(explorePostsProvider.notifier).loadPosts(refresh: true),
        child: postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacing24),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundWhite,
                              shape: BoxShape.circle,
                              boxShadow: AppTheme.cardShadow,
                            ),
                            child: const Icon(
                              Icons.explore_outlined,
                              size: 48,
                              color: AppTheme.primarySky,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing24),
                          Text(
                            context.l10n.explore_screen_empty_message,
                            style: AppTheme.body1.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  ref.read(explorePostsProvider.notifier).loadPosts();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: AppTheme.spacing16,
                  bottom: 100,
                ),
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return const SizedBox(height: AppTheme.spacing24);
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
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primarySky,
              strokeWidth: 3,
            ),
          ),
          error: (err, stack) => ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing24),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundWhite,
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppTheme.accentRed,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing24),
                        Text(
                          context.l10n.explore_screen_error_message,
                          style: AppTheme.body1.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacing32),
                        ElevatedButton.icon(
                          onPressed: () => ref
                              .read(explorePostsProvider.notifier)
                              .loadPosts(refresh: true),
                          icon: const Icon(Icons.refresh),
                          label: Text(context.l10n.retry_button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
