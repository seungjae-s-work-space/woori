// lib/feature/meal_log/widget/my_post_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/localization_extension.dart';
import 'package:woori/utils/talker.dart';

class MyPostCard extends ConsumerStatefulWidget {
  final PostModel post;
  final VoidCallback? onRefresh;

  const MyPostCard({
    super.key,
    required this.post,
    this.onRefresh,
  });

  @override
  ConsumerState<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends ConsumerState<MyPostCard> {
  late PostModel _post;
  bool _isLoadingLogs = false;
  bool _showLogs = false;
  List<Map<String, dynamic>> _activityLogs = [];

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(MyPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post != widget.post) {
      setState(() {
        _post = widget.post;
      });
    }
  }

  Future<void> _loadActivityLogs() async {
    if (_isLoadingLogs) return;

    setState(() {
      _isLoadingLogs = true;
    });

    try {
      final apiClient = ref.read(restApiClientProvider);

      // 댓글 로드
      final commentsResponse =
          await apiClient.get('comments/post/${_post.id}', {});
      final List<dynamic> comments = commentsResponse['data'];

      // 좋아요 로드
      final likesResponse = await apiClient.get('likes/post/${_post.id}', {});

      // 댓글과 좋아요를 하나의 통합된 활동 로그로 변환
      final List<Map<String, dynamic>> logs = [];

      // 댓글을 활동 로그로 변환
      for (final comment in comments) {
        logs.add({
          'type': 'comment',
          'userId': comment['userId'],
          'user': comment['user'],
          'content': comment['content'],
          'createdAt': DateTime.parse(comment['createdAt']),
        });
      }

      // 좋아요 데이터 처리
      // API 응답: { data: { count, isLiked, likes: [...] } }
      final likesData = likesResponse['data'];
      if (likesData is Map && likesData.containsKey('likes')) {
        final likesList = likesData['likes'] as List;
        for (final like in likesList) {
          logs.add({
            'type': 'like',
            'userId': like['userId'],
            'user': like['user'],
            'createdAt': DateTime.parse(like['createdAt']),
          });
        }
      }

      // 시간순으로 정렬 (최신순)
      logs.sort((a, b) =>
          (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));

      setState(() {
        _activityLogs = logs;
        _showLogs = true;
        _isLoadingLogs = false;
      });
    } catch (e) {
      talkerError('my_post_card', '활동 로그 로딩 실패', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.activity_logs_load_error_message)),
        );
        setState(() {
          _isLoadingLogs = false;
        });
      }
    }
  }

  void _toggleLogs() {
    if (_showLogs) {
      setState(() {
        _showLogs = false;
      });
    } else {
      if (_activityLogs.isEmpty) {
        _loadActivityLogs();
      } else {
        setState(() {
          _showLogs = true;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month}.${date.day}';
  }

  String _formatDateDetail(DateTime date) {
    return '${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    // 좋아요와 댓글 수의 합계
    final int totalActivities = _post.likeCount + _post.commentCount;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 및 시간
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacing16,
              AppTheme.spacing16,
              AppTheme.spacing16,
              AppTheme.spacing12,
            ),
            child: Row(
              children: [
                Text(
                  _formatDate(_post.createdAt),
                  style: AppTheme.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  _formatDateDetail(_post.createdAt),
                  style: AppTheme.caption.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // 게시글 내용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            child: Text(
              _post.content,
              style: AppTheme.body1.copyWith(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),

          // 이미지가 있는 경우
          if (_post.imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: Image.network(
                  _post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 활동 수 및 로그 버튼
          if (totalActivities > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing12,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.divider,
                    width: 1,
                  ),
                ),
              ),
              child: InkWell(
                onTap: _toggleLogs,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing4,
                    horizontal: AppTheme.spacing8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showLogs
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: AppTheme.spacing4),
                      Text(
                        context.l10n.activity_logs_count(totalActivities),
                        style: AppTheme.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 활동 로그 (접을 수 있는 형태)
          if (_showLogs) ...[
            const Divider(height: 1, color: AppTheme.divider),
            Container(
              color: AppTheme.backgroundLight,
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: _isLoadingLogs
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.spacing8),
                        child: CircularProgressIndicator(
                          color: AppTheme.primarySky,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : _activityLogs.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacing8),
                            child: Text(
                              context.l10n.no_activity_logs,
                              style: AppTheme.caption,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _activityLogs.length,
                          itemBuilder: (context, index) {
                            final log = _activityLogs[index];
                            final isComment = log['type'] == 'comment';
                            final user = log['user'];
                            final DateTime createdAt = log['createdAt'];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 프로필 이미지 또는 이니셜
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppTheme.primarySkyLight,
                                    foregroundColor: AppTheme.primarySkyDark,
                                    child: Text(
                                      user['nickname']
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: AppTheme.caption.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacing8),

                                  // 활동 내용
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: AppTheme.caption.copyWith(
                                              color: AppTheme.textPrimary,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: user['nickname'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: isComment
                                                    ? context.l10n
                                                        .activity_comment_text
                                                    : context.l10n
                                                        .activity_like_text,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isComment) ...[
                                          const SizedBox(height: AppTheme.spacing4),
                                          Text(
                                            log['content'],
                                            style: AppTheme.caption.copyWith(
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 2),
                                        Text(
                                          timeago.format(
                                            createdAt,
                                            locale:
                                                Localizations.localeOf(context)
                                                    .languageCode,
                                          ),
                                          style: AppTheme.caption.copyWith(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 활동 타입 아이콘
                                  Icon(
                                    isComment
                                        ? Icons.comment_outlined
                                        : Icons.favorite,
                                    size: 16,
                                    color: isComment
                                        ? AppTheme.primarySky
                                        : AppTheme.accentRed,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ],
      ),
    );
  }
}
