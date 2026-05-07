import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:mbh/app/core/logging/app_logger.dart';
import 'package:mbh/app/core/network/client/api_client.dart';
import 'package:mbh/app/core/network/network_service.dart';

enum UploadStatus { idle, uploading, success, failed }

class UploadProgress {
  const UploadProgress({required this.sent, required this.total});

  final int sent;
  final int total;

  double get fraction => total > 0 ? sent / total : 0;
}

class UploadService extends GetxService {
  UploadService(this._logger);

  final AppLogger _logger;

  ApiClient get _apiClient => Get.find<NetworkService>().apiClient;

  Future<Response<dynamic>> uploadFile({
    required String path,
    required String filePath,
    String fileField = 'file',
    Map<String, dynamic>? extra,
    void Function(UploadProgress progress)? onProgress,
  }) async {
    final FormData formData = FormData.fromMap(<String, dynamic>{
      fileField: await MultipartFile.fromFile(filePath),
      if (extra != null) ...extra,
    });

    _logger.debug('Upload start -> $path');

    return _apiClient.raw.post<dynamic>(
      path,
      data: formData,
      onSendProgress: (int sent, int total) {
        onProgress?.call(UploadProgress(sent: sent, total: total));
      },
    );
  }

  Future<Response<dynamic>> uploadBytes({
    required String path,
    required List<int> bytes,
    required String fileName,
    String fileField = 'file',
    void Function(UploadProgress progress)? onProgress,
  }) async {
    final FormData formData = FormData.fromMap(<String, dynamic>{
      fileField: MultipartFile.fromBytes(bytes, filename: fileName),
    });

    return _apiClient.raw.post<dynamic>(
      path,
      data: formData,
      onSendProgress: (int sent, int total) {
        onProgress?.call(UploadProgress(sent: sent, total: total));
      },
    );
  }
}
