import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori/feature/lookaround/explore_screen.dart';
import 'package:woori/feature/mymenu/mymenu_screen.dart';
import 'package:woori/feature/meal_log/meal_log_screen.dart';
import 'package:woori/utils/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundWhite,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ExploreScreen(),
          MealLogScreen(),
          MyMenuScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.favorite : Icons.favorite_border,
              ),
              label: context.l10n.main_screen_explore,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1
                    ? Icons.restaurant
                    : Icons.restaurant_outlined,
              ),
              label: context.l10n.meal_log,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2 ? Icons.person : Icons.person_outline,
              ),
              label: context.l10n.main_screen_my_menu,
            ),
          ],
        ),
      ),
    );
  }
}
