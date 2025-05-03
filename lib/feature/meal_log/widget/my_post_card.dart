// lib/feature/meal_log/widget/my_post_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/data/rest_api_client/rest_api_client.dart';
import 'package:woori/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
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

      // 좋아요 로드 - 응답 구조 확인 및 적응
      final likesResponse = await apiClient.get('likes/post/${_post.id}', {});

      // 로그에 실제 응답 구조 출력
      talkerError('my_post_card', '좋아요 응답 구조: ${likesResponse['data']}', '');

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

      // 좋아요 데이터가 여러 형태로 올 수 있으므로 타입 확인 후 처리
      final likesData = likesResponse['data'];
      if (likesData is List) {
        // 목록 형태인 경우
        for (final like in likesData) {
          logs.add({
            'type': 'like',
            'userId': like['userId'],
            'user': like['user'],
            'createdAt': DateTime.parse(like['createdAt']),
          });
        }
      } else if (likesData is Map && likesData.containsKey('likes')) {
        // Map 내부에 목록이 있는 경우
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
      // 다른 형태의 응답은 여기서 처리 가능

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

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 내 게시글 표시 배지
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _formatDate(_post.createdAt),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _formatDateDetail(_post.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 게시글 내용
          Text(
            _post.content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),

          // 이미지가 있는 경우
          if (_post.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          totalActivities > 0
              ?
              // 활동 수 및 로그 버튼
              InkWell(
                  onTap: _toggleLogs,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _showLogs
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 20,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              totalActivities > 0
                                  ? context.l10n
                                      .activity_logs_count(totalActivities)
                                  : context.l10n.no_activity_logs,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),

          // 활동 로그 (접을 수 있는 형태)
          if (_showLogs) ...[
            const Divider(height: 24),
            _isLoadingLogs
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _activityLogs.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.l10n.no_activity_logs),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 프로필 이미지 또는 이니셜
                                CircleAvatar(
                                  radius: 16,
                                  child: Text(user['nickname'].substring(0, 1)),
                                ),
                                const SizedBox(width: 8),

                                // 활동 내용
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: user['nickname'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: isComment
                                                  ? context.l10n
                                                      .activity_comment_text
                                                  : context
                                                      .l10n.activity_like_text,
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isComment) ...[
                                        const SizedBox(height: 4),
                                        Text(log['content']),
                                      ],
                                      const SizedBox(height: 2),
                                      Text(
                                        timeago.format(
                                          createdAt,
                                          locale:
                                              Localizations.localeOf(context)
                                                  .languageCode,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.grey[600],
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
                                  color: isComment ? Colors.blue : Colors.red,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ],
        ],
      ),
    );
  }
}
