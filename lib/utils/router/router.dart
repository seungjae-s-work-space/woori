import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/common/screen/not_found_screen.dart';
import 'package:woori/feature/auth/dash/dash_screen.dart';
import 'package:woori/feature/auth/login/login_screen.dart';
import 'package:woori/feature/auth/signup/sign_up_screen.dart';
import 'package:woori/feature/camera/camera_screen.dart';
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
        builder: (context, state) => const MainScreen(),
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
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
    ],
  );
});

/**
 * 로그인으로 가는 페이지
 * 로그인 페이지
 * 카메라 페이지
 *
 */
