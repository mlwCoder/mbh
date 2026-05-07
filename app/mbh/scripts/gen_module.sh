#!/bin/bash

set -e

MODULE_NAME="$1"

if [ -z "$MODULE_NAME" ]; then
  echo "Usage: ./scripts/gen_module.sh <module_name>"
  echo "Example: ./scripts/gen_module.sh order"
  exit 1
fi

BASE_DIR="lib/app/modules/$MODULE_NAME"

if [ -d "$BASE_DIR" ]; then
  echo "Error: Module '$MODULE_NAME' already exists at $BASE_DIR"
  exit 1
fi

PASCAL_NAME=$(echo "$MODULE_NAME" | sed -r 's/(^|_)(\w)/\U\2/g')

echo "Creating module: $MODULE_NAME ($PASCAL_NAME)"

mkdir -p "$BASE_DIR/bindings"
mkdir -p "$BASE_DIR/controllers"
mkdir -p "$BASE_DIR/models"
mkdir -p "$BASE_DIR/repositories"
mkdir -p "$BASE_DIR/views"
mkdir -p "$BASE_DIR/widgets"

cat > "$BASE_DIR/bindings/${MODULE_NAME}_binding.dart" << EOF
import 'package:get/get.dart';
import 'package:mbh/app/modules/$MODULE_NAME/controllers/${MODULE_NAME}_controller.dart';
import 'package:mbh/app/modules/$MODULE_NAME/repositories/${MODULE_NAME}_repository.dart';

class ${PASCAL_NAME}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${PASCAL_NAME}Repository>(${PASCAL_NAME}Repository.new);
    Get.lazyPut<${PASCAL_NAME}Controller>(
      () => ${PASCAL_NAME}Controller(Get.find<${PASCAL_NAME}Repository>()),
    );
  }
}
EOF

cat > "$BASE_DIR/controllers/${MODULE_NAME}_controller.dart" << EOF
import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/modules/$MODULE_NAME/repositories/${MODULE_NAME}_repository.dart';

class ${PASCAL_NAME}Controller extends BaseController {
  ${PASCAL_NAME}Controller(this._repository);

  final ${PASCAL_NAME}Repository _repository;

  @override
  void onReady() {
    super.onReady();
  }
}
EOF

cat > "$BASE_DIR/repositories/${MODULE_NAME}_repository.dart" << EOF
import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_repository.dart';
import 'package:mbh/app/core/network/network_service.dart';

class ${PASCAL_NAME}Repository extends BaseRepository {
  ${PASCAL_NAME}Repository() : _networkService = Get.find<NetworkService>();

  final NetworkService _networkService;
}
EOF

cat > "$BASE_DIR/views/${MODULE_NAME}_page.dart" << EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/modules/$MODULE_NAME/controllers/${MODULE_NAME}_controller.dart';
import 'package:mbh/app/shared/shared.dart';

class ${PASCAL_NAME}Page extends GetView<${PASCAL_NAME}Controller> {
  const ${PASCAL_NAME}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '$PASCAL_NAME'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoading();
        }

        return const AppEmpty();
      }),
    );
  }
}
EOF

echo ""
echo "Module '$MODULE_NAME' created successfully at $BASE_DIR"
echo ""
echo "Next steps:"
echo "  1. Add route to lib/app/core/routing/app_routes.dart"
echo "  2. Add GetPage to lib/app/core/routing/app_pages.dart"
echo "  3. Add models to $BASE_DIR/models/"
echo "  4. Implement repository methods in $BASE_DIR/repositories/"
echo "  5. Implement controller logic in $BASE_DIR/controllers/"
echo "  6. Build page UI in $BASE_DIR/views/"
