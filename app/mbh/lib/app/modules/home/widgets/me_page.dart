import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/routing/app_routes.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  static const Color _primaryPink = Color(0xFFFF4B73);
  static const Color _softPink = Color(0xFFFFE6EC);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final bool isLoggedIn = authService.hasToken;

    final List<_OrderActionItem> orderActions = <_OrderActionItem>[
      const _OrderActionItem(icon: Icons.payments_outlined, label: '待付款'),
      const _OrderActionItem(icon: Icons.inventory_2_outlined, label: '待发货'),
      const _OrderActionItem(icon: Icons.local_shipping_outlined, label: '待收货'),
      const _OrderActionItem(icon: Icons.chat_bubble_outline_rounded, label: '待评价'),
      const _OrderActionItem(icon: Icons.currency_yen_rounded, label: '退款'),
    ];

    final List<_MenuItemData> menus = <_MenuItemData>[
      const _MenuItemData(icon: Icons.confirmation_number_outlined, title: '我的优惠券', onTapRoute: AppRoutes.coupon),
      const _MenuItemData(icon: Icons.account_balance_wallet_outlined, title: '我的钱包', onTapRoute: AppRoutes.wallet),
      const _MenuItemData(icon: Icons.favorite_border_rounded, title: '我的收藏', onTapRoute: AppRoutes.favoriteList),
      const _MenuItemData(icon: Icons.support_agent_outlined, title: '在线客服', onTapRoute: AppRoutes.customerService),
      const _MenuItemData(icon: Icons.location_on_outlined, title: '收货地址', onTapRoute: AppRoutes.address),
      const _MenuItemData(icon: Icons.workspace_premium_outlined, title: '申请成为商家', onTapRoute: AppRoutes.merchantApply),
      const _MenuItemData(
        icon: Icons.settings_outlined,
        title: '设置',
        showDivider: false,
        onTapRoute: AppRoutes.settings,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _MeHeader(orderActions: orderActions, isLoggedIn: isLoggedIn),
                Transform.translate(
                  offset: const Offset(0, -14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionCard(
                      child: Column(
                        children: menus
                            .map((item) => _MenuRow(item: item))
                            .toList(growable: false),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLoggedIn)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.login),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: _softPink,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1AFF4B73),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          '登录以访问更多功能',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _primaryPink,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: _primaryPink,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '立即登录',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MeHeader extends StatelessWidget {
  const _MeHeader({required this.orderActions, required this.isLoggedIn});

  final List<_OrderActionItem> orderActions;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFFFF4B73),
            Color(0xFFFF7B93),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    isLoggedIn ? '已登录用户' : '8888 8888 444433',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '我的订单',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '全部',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: orderActions
                      .map((item) => _OrderActionButton(item: item))
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  const _OrderActionButton({required this.item});

  final _OrderActionItem item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 28, color: const Color(0xFF374151)),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final _MenuItemData item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTapRoute == null ? null : () => Get.toNamed(item.onTapRoute!),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: item.showDivider ? const Color(0xFFF1F5F9) : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 25, color: const Color(0xFF374151)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderActionItem {
  const _OrderActionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _MenuItemData {
  const _MenuItemData({
    required this.icon,
    required this.title,
    this.showDivider = true,
    this.onTapRoute,
  });

  final IconData icon;
  final String title;
  final bool showDivider;
  final String? onTapRoute;
}
