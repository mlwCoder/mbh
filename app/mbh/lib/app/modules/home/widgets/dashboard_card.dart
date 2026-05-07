import 'package:flutter/material.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/modules/home/models/dashboard_item.dart';
import 'package:mbh/app/shared/shared.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({required this.item, super.key});

  final DashboardItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: context.appTextTheme.bodyMedium?.copyWith(
              color: context.appTheme.mutedText,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.value,
                style: context.appTextTheme.headlineMedium,
              ),
              if (item.unit != null) ...[
                const SizedBox(width: Spacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    item.unit!,
                    style: context.appTextTheme.bodyMedium?.copyWith(
                      color: context.appTheme.mutedText,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
