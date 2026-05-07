import 'package:get/get.dart';
import 'package:mbh/app/core/localization/translations/en_us.dart';
import 'package:mbh/app/core/localization/translations/ru_ru.dart';
import 'package:mbh/app/core/localization/translations/zh_cn.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': zhCN,
        'en_US': enUS,
        'ru_RU': ruRU,
      };
}
