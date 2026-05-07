import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_service.dart';
import 'package:mbh/app/core/network/client/api_client.dart';

class NetworkService extends BaseService {
  NetworkService(this._apiClient);

  final ApiClient _apiClient;

  ApiClient get apiClient => _apiClient;
}
