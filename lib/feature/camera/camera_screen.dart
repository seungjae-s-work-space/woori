import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/utils/image_generated/assets.gen.dart';
import 'package:woori/utils/localization_extension.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _controller = CameraController(cameras![0], ResolutionPreset.high);
        await _controller!.initialize();
        if (!mounted) return;
        setState(() => isCameraInitialized = true);
      }
    } catch (e) {
      print("카메라 초기화 실패: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    // [시뮬레이터 테스트용]  ////디비 photo 활성화 해야함.
    // 카메라 초기화/촬영 로직 잠시 주석 처리
    // if (_controller == null || !_controller!.value.isInitialized) {
    //   return;
    // }
    // try {
    //   final picture = await _controller!.takePicture();
    //   if (!mounted) return;
    //   context.go('createPost', extra: picture.path);
    // } catch (e) {
    //   debugPrint("사진 찍기 실패: $e");
    // }

    // [대신 더미 경로를 넘기기]
    // const dummyPath = 'assets/images/dash/appLogo.png';
    context.pushReplacement('/camera/createPost'); // <-- 절대 경로
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📷 카메라 프리뷰 (배경)
          if (isCameraInitialized && _controller != null)
            Positioned.fill(
              child: CameraPreview(_controller!),
            )
          else
            Positioned.fill(
              child: Container(color: Colors.white), // 카메라 미초기화 시 검은 화면
            ),

          // 🔘 상단 비율 선택 버튼
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ratioButton("1:1"),
                  _ratioButton("3:4"),
                ],
              ),
            ),
          ),

          // 📸 하단 촬영 및 페이지 이동 버튼
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _bottomButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📸 촬영 버튼 및 네비게이션 버튼 UI
  Widget _bottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, size: 50),
                    onPressed: () => context.pushReplacement('/',
                        extra: 0), // 🏠 "구경하기" 클릭 시 인덱스 0 전달
                  ),
                  Text(context.l10n.look_around)
                ],
              ),
              Container(
                width: 90,
                height: 1,
                decoration: BoxDecoration(color: Colors.grey.shade800),
              ),
              Assets.images.dash.flowerCharacter.image(
                // 그냥 빈자리, 기능 추가하거나 화면 바꾸자.
                width: 50,
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _takePhoto(), // 촬영 버튼은 그대로 유지
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade800,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade800,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.restaurant_menu, size: 50),
                    onPressed: () => context.pushReplacement('/',
                        extra: 1), // 🍽️ "식사 기록" 클릭 시 인덱스 1 전달
                  ),
                  Text(context.l10n.meal_log)
                ],
              ),
              Container(
                width: 90,
                height: 1,
                decoration: BoxDecoration(color: Colors.grey.shade800),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.person_outline, size: 50),
                    onPressed: () => context.pushReplacement('/',
                        extra: 2), // 🍽️ "식사 기록" 클릭 시 인덱스 1 전달
                  ),
                  Text(context.l10n.my_menu)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔘 1:1, 3:4 버튼 UI
  Widget _ratioButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TextButton(
        onPressed: () => print("$text 선택"),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  /// ⬇️ 하단 네비게이션 버튼
  Widget _bottomNavButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onTap,
        ),
        Text(label),
      ],
    );
  }
}
