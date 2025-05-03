import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/dto/create_post_dto.dart';
import 'package:woori/feature/camera/provider/post_provider.dart';
import 'package:woori/utils/dialog/panara_dialog.dart';
import 'package:woori/utils/interceptor/error_code_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  // final String imagePath;

  const CreatePostScreen({
    super.key,
    // required this.imagePath,
  });

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

  void _onSubmit() async {
    if (context.mounted) {
      try {
        final postNotifier = ref.read(postProvider.notifier);

        final createPostDto = CreatePostDto(
          content: _textController.text.trim(),
          // imagePath: widget.imagePath,
        );

        await postNotifier.createPost(createPostDto);

        if (context.mounted) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.restart_alt),
          onPressed: () {
            context.go('/camera');
          },
        ),
      ),
      body: Column(
        children: [
          // 사진 미리보기
          Expanded(
              child: Container(
            height: 160,
            color: Colors.grey[300],
          )
              // Image.file(
              //   File(widget.imagePath),
              //   fit: BoxFit.cover,
              // ),
              ),

          // 텍스트 입력
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '글 내용을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 등록 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => context.go('/camera'),
                  child: const Text('취소하기'),
                ),
              ),
              SizedBox(width: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('등록하기'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
