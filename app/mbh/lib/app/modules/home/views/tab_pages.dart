import 'package:flutter/material.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TabScaffold(title: '首页');
  }
}

class CategoryTabPage extends StatelessWidget {
  const CategoryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TabScaffold(title: '分类');
  }
}

class FavoriteTabPage extends StatelessWidget {
  const FavoriteTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TabScaffold(title: '收藏');
  }
}

class CartTabPage extends StatelessWidget {
  const CartTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TabScaffold(title: '购物车');
  }
}

class _TabScaffold extends StatelessWidget {
  const _TabScaffold({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }
}
