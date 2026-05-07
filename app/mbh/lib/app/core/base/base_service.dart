import 'package:get/get.dart';

abstract class BaseService extends GetxService {
  Future<BaseService> init() async {
    return this;
  }
}
