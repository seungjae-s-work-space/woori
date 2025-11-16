import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/feature/meal_log/provider/meal_log_provider.dart';
import 'package:woori/feature/meal_log/widget/my_post_card.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/appbar/app_bar.dart';
import 'package:woori/utils/localization_extension.dart';

class MealLogScreen extends ConsumerWidget {
  const MealLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(mealLogPostsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: buildAppBarContent(context, 1, context.l10n.meal_log, index: 0),
      body: RefreshIndicator(
        color: AppTheme.primarySky,
        backgroundColor: AppTheme.backgroundWhite,
        onRefresh: () => ref.read(mealLogPostsProvider.notifier).loadPosts(),
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
                              Icons.restaurant_outlined,
                              size: 48,
                              color: AppTheme.primarySky,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing24),
                          Text(
                            context.l10n.meal_log_screen_empty_message,
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
            return ListView.builder(
              padding: const EdgeInsets.only(
                top: AppTheme.spacing16,
                bottom: 100,
              ),
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
                          context.l10n.meal_log_screen_error_message,
                          style: AppTheme.body1.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacing32),
                        ElevatedButton.icon(
                          onPressed: () =>
                              ref.read(mealLogPostsProvider.notifier).loadPosts(),
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
