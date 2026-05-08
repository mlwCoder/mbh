import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleFeaturePage extends StatelessWidget {
  const SimpleFeaturePage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}

class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleFeaturePage(title: '我的优惠券');
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleFeaturePage(title: '我的钱包');
  }
}

class FavoriteListPage extends StatelessWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleFeaturePage(title: '我的收藏');
  }
}

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleFeaturePage(title: '在线客服');
  }
}

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleFeaturePage(title: '收货地址');
  }
}

class MerchantApplyPage extends StatelessWidget {
  const MerchantApplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleFeaturePage(title: '申请成为商家');
  }
}
