#!/bin/bash

set -e

MODULE_NAME="$1"
PAGE_NAME="$2"

if [ -z "$MODULE_NAME" ] || [ -z "$PAGE_NAME" ]; then
  echo "Usage: ./scripts/gen_page.sh <module_name> <page_name>"
  echo "Example: ./scripts/gen_page.sh order order_detail"
  exit 1
fi

BASE_DIR="lib/app/modules/$MODULE_NAME"

if [ ! -d "$BASE_DIR" ]; then
  echo "Error: Module '$MODULE_NAME' does not exist. Run gen_module.sh first."
  exit 1
fi

PASCAL_PAGE=$(echo "$PAGE_NAME" | sed -r 's/(^|_)(\w)/\U\2/g')

VIEW_FILE="$BASE_DIR/views/${PAGE_NAME}_page.dart"

if [ -f "$VIEW_FILE" ]; then
  echo "Error: Page '$PAGE_NAME' already exists at $VIEW_FILE"
  exit 1
fi

cat > "$VIEW_FILE" << EOF
import 'package:flutter/material.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/shared/shared.dart';

class ${PASCAL_PAGE}Page extends StatelessWidget {
  const ${PASCAL_PAGE}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '$PASCAL_PAGE'),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Text(
          '$PASCAL_PAGE Page',
          style: context.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
EOF

echo "Page '$PAGE_NAME' created at $VIEW_FILE"
echo ""
echo "Next steps:"
echo "  1. Add route constant to app_routes.dart"
echo "  2. Register GetPage in app_pages.dart"
