/// AI Module Contract
///
/// Defines the minimum structure a generated module must satisfy.

abstract class AiModuleContract {
  /// Module must have bindings/<module>_binding.dart
  void binding();

  /// Module must have controllers/<module>_controller.dart
  void controller();

  /// Module must have repositories/<module>_repository.dart
  void repository();

  /// Module must have views/<page>_page.dart (at least one)
  void view();

  /// Module must register its route in AppPages
  void route();
}
