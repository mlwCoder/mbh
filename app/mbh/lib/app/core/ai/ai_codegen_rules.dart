/// AI Codegen Rules for MBH Enterprise Flutter Scaffold
///
/// This file defines the contracts and constraints that AI tools
/// (such as Cursor) must follow when generating code in this project.

class AiCodegenRules {
  const AiCodegenRules._();

  /// Every module follows this directory structure:
  ///
  /// ```
  /// modules/<module_name>/
  /// ├── bindings/<module_name>_binding.dart
  /// ├── controllers/<module_name>_controller.dart
  /// ├── models/
  /// ├── repositories/<module_name>_repository.dart
  /// ├── views/<page_name>_page.dart
  /// └── widgets/
  /// ```
  static const String moduleTemplate = 'modules/<module_name>/';

  /// File naming rules:
  /// - All files use snake_case
  /// - Controllers: <name>_controller.dart
  /// - Bindings: <name>_binding.dart
  /// - Views: <name>_page.dart
  /// - Repositories: <name>_repository.dart
  /// - Models: <name>.dart
  /// - Widgets: <name>.dart
  static const String fileNaming = 'snake_case';

  /// Class naming rules:
  /// - All classes use PascalCase
  /// - Controllers: <Name>Controller
  /// - Bindings: <Name>Binding
  /// - Views: <Name>Page
  /// - Repositories: <Name>Repository
  static const String classNaming = 'PascalCase';

  /// UI rules:
  /// - No hardcoded colors → use AppColors / context.colorScheme
  /// - No hardcoded spacing → use Spacing.xs/sm/md/lg/xl/xxl
  /// - No hardcoded radius → use AppRadius.sm/md/lg/xl
  /// - No hardcoded text → use LocaleKeys.xxx.tr
  /// - No raw TextField → use AppInput
  /// - No raw ElevatedButton → use AppButton
  /// - No raw AppBar → use AppAppBar
  /// - No raw AlertDialog → use AppDialog
  /// - Use context.appTextTheme / context.appTheme for styling
  static const String uiRules = 'token_based';

  /// Architecture rules:
  /// - View must not call ApiClient directly
  /// - View must not contain business logic
  /// - Controller calls Repository, not ApiClient
  /// - Repository returns Result<T>, never throws
  /// - Models use factory fromJson constructor
  /// - All routes registered in AppPages with Binding
  /// - All routes protected by appropriate middleware
  static const String architectureRules = 'mvvm_repository';

  /// Page size rules:
  /// - Single page file must not exceed 300 lines
  /// - Single controller must not exceed 200 lines
  /// - Extract widgets into widgets/ when page > 200 lines
  static const int maxPageLines = 300;
  static const int maxControllerLines = 200;

  /// i18n rules:
  /// - Key format: <module>.<submodule>.<key>
  /// - Example: auth.login.title, home.dashboard.empty
  /// - All user-visible text must use LocaleKeys
  /// - Must add keys to zh_cn.dart, en_us.dart, ru_ru.dart
  static const String i18nKeyFormat = '<module>.<submodule>.<key>';

  /// Route rules:
  /// - Route path defined in AppRoutes as static const
  /// - GetPage registered in AppPages.pages
  /// - Page must have a Binding
  /// - Protected pages must use AuthMiddleware
  /// - Guest-only pages must use GuestMiddleware
  static const String routeRules = 'centralized';
}
