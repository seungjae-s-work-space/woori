import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/lookaround/explore_screen.dart';
import 'package:woori/feature/mymenu/mymenu_screen.dart';
import 'package:woori/feature/meal_log/meal_log_screen.dart';
import 'package:woori/utils/localization_extension.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.extra});

  final int? extra;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.extra ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ExploreScreen(),
          MealLogScreen(),
          MyMenuScreen(),
          // MyMenuScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: context.l10n.main_screen_explore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo_library),
            label: context.l10n.main_screen_meal_log,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.l10n.main_screen_my_menu,
          ),
        ],
      ),
    );
  }
}
