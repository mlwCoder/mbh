import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/modules/home/controllers/home_controller.dart';
import 'package:mbh/app/modules/home/views/tab_pages.dart';
import 'package:mbh/app/modules/home/widgets/me_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static const List<_TabItem> _tabs = <_TabItem>[
    _TabItem(label: '首页', icon: Icons.home_outlined, activeIcon: Icons.home),
    _TabItem(label: '分类', icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded),
    _TabItem(label: '收藏', icon: Icons.favorite_border_rounded, activeIcon: Icons.favorite_rounded),
    _TabItem(label: '购物车', icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart_rounded),
    _TabItem(label: '我的', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int index = controller.currentIndex.value;
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: IndexedStack(
          index: index,
          children: const [
            HomeTabPage(),
            CategoryTabPage(),
            FavoriteTabPage(),
            CartTabPage(),
            MePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: controller.changeTab,
          selectedItemColor: const Color(0xFFFF4B73),
          unselectedItemColor: const Color(0xFF9CA3AF),
          backgroundColor: Colors.white,
          items: _tabs
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  activeIcon: Icon(item.activeIcon),
                  label: item.label,
                ),
              )
              .toList(growable: false),
        ),
      );
    });
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
