import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';
import 'package:mbh/app/core/routing/app_routes.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/modules/home/controllers/home_controller.dart';
import 'package:mbh/app/modules/home/widgets/dashboard_card.dart';
import 'package:mbh/app/shared/shared.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: LocaleKeys.homeTitle.tr,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const AppLoading();
    }

    if (controller.hasError.value) {
      return AppErrorView(onRetry: controller.loadDashboard);
    }

    if (controller.dashboardItems.isEmpty) {
      return const AppEmpty();
    }

    return RefreshIndicator(
      onRefresh: controller.loadDashboard,
      child: ListView.separated(
        padding: const EdgeInsets.all(Spacing.xxl),
        itemCount: controller.dashboardItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: Spacing.lg),
        itemBuilder: (_, int index) {
          return DashboardCard(item: controller.dashboardItems[index]);
        },
      ),
    );
  }
}
