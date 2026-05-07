import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_repository.dart';
import 'package:mbh/app/core/base/result.dart';
import 'package:mbh/app/core/errors/error_handler.dart';
import 'package:mbh/app/core/network/network_service.dart';
import 'package:mbh/app/modules/home/models/dashboard_item.dart';

class HomeRepository extends BaseRepository {
  HomeRepository() : _networkService = Get.find<NetworkService>();

  final NetworkService _networkService;

  Future<Result<List<DashboardItem>>> fetchDashboard() async {
    try {
      final response = await _networkService.apiClient.get<List<dynamic>>(
        '/dashboard',
        fromJsonT: (Object? json) => json as List<dynamic>,
      );

      if (response.success && response.data != null) {
        final List<DashboardItem> items = response.data!
            .map((dynamic e) => DashboardItem.fromJson(e))
            .toList();
        return Success<List<DashboardItem>>(items);
      }

      return FailureResult<List<DashboardItem>>(
        ErrorHandler.handle(Exception(response.message)),
      );
    } catch (e, s) {
      return FailureResult<List<DashboardItem>>(ErrorHandler.handle(e, s));
    }
  }
}
