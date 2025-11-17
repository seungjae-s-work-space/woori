import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woori/utils/talker.dart';

final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, ImagePickerState>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<ImagePickerState> {
  ImagePickerNotifier() : super(ImagePickerState());

  final ImagePicker _picker = ImagePicker();

  /// 카메라로 사진 촬영
  Future<void> pickFromCamera() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // 품질 조정 (0-100)
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (photo != null) {
        final compressedFile = await _compressImage(photo.path);
        state = state.copyWith(
          selectedImage: compressedFile,
          isLoading: false,
        );
        talkerInfo('ImagePicker', '카메라 촬영 성공: ${compressedFile.path}');
      } else {
        state = state.copyWith(isLoading: false);
        talkerInfo('ImagePicker', '카메라 촬영 취소');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '카메라 오류: $e',
      );
      talkerError('ImagePicker', '카메라 촬영 실패', e);
    }
  }

  /// 갤러리에서 사진 선택
  Future<void> pickFromGallery() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        final compressedFile = await _compressImage(image.path);
        state = state.copyWith(
          selectedImage: compressedFile,
          isLoading: false,
        );
        talkerInfo('ImagePicker', '갤러리 선택 성공: ${compressedFile.path}');
      } else {
        state = state.copyWith(isLoading: false);
        talkerInfo('ImagePicker', '갤러리 선택 취소');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '갤러리 오류: $e',
      );
      talkerError('ImagePicker', '갤러리 선택 실패', e);
    }
  }

  /// 이미지 압축
  Future<File> _compressImage(String imagePath) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        targetPath,
        quality: 85,
        minWidth: 1920,
        minHeight: 1920,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        final originalSize = await File(imagePath).length();
        final compressedSize = await compressedFile.length();
        talkerInfo(
          'ImageCompress',
          '압축 완료: ${(originalSize / 1024).toStringAsFixed(1)}KB → ${(compressedSize / 1024).toStringAsFixed(1)}KB',
        );
        return File(compressedFile.path);
      }

      return File(imagePath);
    } catch (e) {
      talkerError('ImageCompress', '압축 실패, 원본 사용', e);
      return File(imagePath);
    }
  }

  /// 선택한 이미지 제거
  void clearImage() {
    state = state.copyWith(clearImage: true, error: null);
  }
}

class ImagePickerState {
  final File? selectedImage;
  final bool isLoading;
  final String? error;

  ImagePickerState({
    this.selectedImage,
    this.isLoading = false,
    this.error,
  });

  ImagePickerState copyWith({
    File? selectedImage,
    bool? isLoading,
    String? error,
    bool clearImage = false,
  }) {
    return ImagePickerState(
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
