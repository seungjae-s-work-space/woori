import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/lookaround/explore_screen.dart';
import 'package:woori/feature/meallog/meallog_screen.dart';
import 'package:woori/feature/gallery/gallery_screen.dart';
import 'package:woori/feature/mymenu/mymenu_screen.dart';
import 'package:woori/feature/main/main_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainTabProvider); // 현재 선택된 탭 상태

    final List<Widget> pages = [
      // const ExploreScreen(),
      // const MealLogScreen(),
      // const GalleryScreen(),
      // const MyMenuScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => ref.read(mainTabProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "구경하기"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "식사기록"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "사진첩"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "마이메뉴"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/camera'),
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
