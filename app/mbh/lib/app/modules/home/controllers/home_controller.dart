import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/core/base/result.dart';
import 'package:mbh/app/modules/home/models/dashboard_item.dart';
import 'package:mbh/app/modules/home/repositories/home_repository.dart';
import 'package:mbh/app/shared/shared.dart';

class HomeController extends BaseController {
  HomeController(this._homeRepository);

  final HomeRepository _homeRepository;

  final RxList<DashboardItem> dashboardItems = <DashboardItem>[].obs;
  final RxBool hasError = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    showLoading();
    hasError.value = false;

    final Result<List<DashboardItem>> result = await _homeRepository.fetchDashboard();

    hideLoading();

    result.when(
      success: (List<DashboardItem> data) {
        dashboardItems.assignAll(data);
      },
      failure: (failure) {
        hasError.value = true;
        AppToast.show(failure.message);
      },
    );
  }
}
