/// AI Page Contract
///
/// Defines what a generated page must contain for it to be considered
/// "complete" by this scaffold's standards.

abstract class AiPageContract {
  /// Every page must have a Binding class.
  void binding();

  /// Every page must have a Controller extending BaseController.
  void controller();

  /// Every page view must extend GetView<Controller> or StatelessWidget.
  void view();

  /// Optional: pages with data must have a Repository.
  void repository();

  /// Optional: pages with complex data must have Models.
  void models();
}
