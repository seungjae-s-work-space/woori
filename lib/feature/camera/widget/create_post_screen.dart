import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/dto/create_post_dto.dart';
import 'package:woori/feature/camera/provider/image_picker_provider.dart';
import 'package:woori/feature/camera/provider/post_provider.dart';
import 'package:woori/utils/app_theme.dart';
import 'package:woori/utils/dialog/panara_dialog.dart';
import 'package:woori/utils/interceptor/error_code_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          '사진 선택',
          style: AppTheme.heading2.copyWith(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primarySky),
              title: const Text('카메라로 촬영'),
              onTap: () {
                Navigator.pop(context);
                ref.read(imagePickerProvider.notifier).pickFromCamera();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppTheme.primarySky),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                ref.read(imagePickerProvider.notifier).pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (_textController.text.trim().isEmpty) {
      showErrorDialog(context, '내용을 입력해주세요');
      return;
    }

    if (context.mounted) {
      try {
        final postNotifier = ref.read(postProvider.notifier);
        final imageState = ref.read(imagePickerProvider);

        final createPostDto = CreatePostDto(
          content: _textController.text.trim(),
        );

        await postNotifier.createPost(
          createPostDto,
          imageFile: imageState.selectedImage,
        );

        if (context.mounted) {
          // 이미지 상태 초기화
          ref.read(imagePickerProvider.notifier).clearImage();
          context.go('/');
        }
      } on DioException catch (e) {
        if (context.mounted) {
          showErrorDialog(context, e.getErrorMessage(context));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imagePickerProvider);
    final postState = ref.watch(postProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          '게시물 작성',
          style: AppTheme.heading2.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () {
            ref.read(imagePickerProvider.notifier).clearImage();
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacing16),

            // 이미지 미리보기 또는 선택 버튼
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
              ),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
              child: imageState.selectedImage != null
                  ? Stack(
                      children: [
                        // 이미지 미리보기
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          child: Image.file(
                            imageState.selectedImage!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // 이미지 제거 버튼
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                ref
                                    .read(imagePickerProvider.notifier)
                                    .clearImage();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: _showImageSourceDialog,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppTheme.spacing16),
                              decoration: BoxDecoration(
                                color: AppTheme.primarySkyLight,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusLarge),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: AppTheme.primarySky,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing12),
                            Text(
                              '사진 추가 (선택사항)',
                              style: AppTheme.body1.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: AppTheme.spacing16),

            // 텍스트 입력
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
              ),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _textController,
                maxLines: 8,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: '무슨 생각을 하고 계신가요?',
                  hintStyle: AppTheme.body1.copyWith(
                    color: AppTheme.textHint,
                  ),
                  border: InputBorder.none,
                  counterStyle: AppTheme.caption.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                style: AppTheme.body1.copyWith(fontSize: 15),
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // 등록 버튼
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: postState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(imagePickerProvider.notifier)
                                  .clearImage();
                              context.pop();
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: const BorderSide(color: AppTheme.border),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: postState.isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primarySky,
                        foregroundColor: AppTheme.backgroundWhite,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                      child: postState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppTheme.backgroundWhite,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('등록하기'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),
          ],
        ),
      ),
    );
  }
}
