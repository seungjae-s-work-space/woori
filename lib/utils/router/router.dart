import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/common/screen/not_found_screen.dart';
import 'package:woori/feature/auth/dash/dash_screen.dart';
import 'package:woori/feature/auth/login/login_screen.dart';
import 'package:woori/feature/auth/signup/sign_up_screen.dart';
import 'package:woori/feature/camera/camera_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/dash',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
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
      // GoRoute(
      //   path: '/select_role',
      //   builder: (context, state) => const SelectRoleScreen(),
      // ),

      // Admin Router
      // GoRoute(
      //     path: '/admin',
      //     builder: (context, state) =>
      //         const AdminDashboardScreen(), //AdminDashboardScreen(),
      //     routes: [
      //       GoRoute(
      //         path: '/menus',
      //         builder: (context, state) => const AdminMenuListScreen(),
      //         routes: [
      //           GoRoute(
      //             path: '/add',
      //             builder: (context, state) => const AdminMenuAppendScreen(),
      //           ),
      //           GoRoute(
      //             path: '/categories',
      //             builder: (context, state) =>
      //                 const AdminMenuCategoryListScreen(),
      //           ),
      //           GoRoute(
      //             path: '/soldout',
      //             builder: (context, state) =>
      //                 const AdminMenuSoldoutListScreen(),
      //           ),
      //           GoRoute(
      //             path: '/statics',
      //             builder: (context, state) => const AdminMenuStaticsScreen(),
      //           )
      //         ],
      //       ),
      //       GoRoute(
      //           path: '/tables',
      //           builder: (context, state) => const AdminTableListScreen(),
      //           routes: [
      //             GoRoute(
      //               path: '/add',
      //               builder: (context, state) => const AdminTableAppendScreen(),
      //             ),
      //           ]),
      //       GoRoute(
      //         path: '/orders',
      //         builder: (context, state) => const AdminOrderListScreen(),
      //       ),
      //       GoRoute(
      //         path: '/settings',
      //         builder: (context, state) => const AdminSettingListScreen(),
      //       ),
      //     ]),

      // Account Router

      // Menu Router
      // GoRoute(
      //   path: '/menu',
      //   builder: (context, state) => const MenuScreen(),
      //   routes: [
      //     GoRoute(
      //       path: '/add',
      //       builder: (context, state) => const AddMenuScreen(),
      //     ),
      //   ],
      // ),

      // Order Router
      // GoRoute(
      //   path: '/order',
      //   builder: (context, state) => const OrderManagementScreen(),
      // ),
    ],
  );
});

/**
 * 로그인으로 가는 페이지
 * 로그인 페이지
 * 카메라 페이지
 * 
 */
