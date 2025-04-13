import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/common/screen/not_found_screen.dart';
import 'package:woori/feature/auth/dash/dash_screen.dart';
import 'package:woori/feature/auth/login/login_screen.dart';
import 'package:woori/feature/auth/signup/sign_up_screen.dart';
import 'package:woori/feature/camera/camera_screen.dart';
import 'package:woori/feature/camera/widget/create_post_screen.dart';
import 'package:woori/feature/main/main_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/dash',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final index = state.extra as int? ?? 0;
          return MainScreen(extra: index);
        },
      ),

      // Auth Router
      GoRoute(
        path: '/dash',
        builder: (context, state) => const DashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LogInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      // GoRoute(
      //   path: '/camera',
      //   builder: (context, state) => const CameraScreen(),
      //   routes: [
      //     // GoRoute(
      //     //   // 🚨 여기서 path 앞에 '/'를 붙이지 마세요! (절대 경로가 되어버림)
      //     //   path: 'createPost',
      //     //   builder: (context, state) {
      //     //     final imagePath = state.extra as String? ?? '';
      //     //     return CreatePostScreen(imagePath: imagePath);
      //     //   },
      //     // ),
      //   ],
      // ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/camera/createPost',
        builder: (context, state) => const CreatePostScreen(),
      ),
    ],
  );
});
