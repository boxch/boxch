import 'package:boxch/translate/en.dart';
import 'package:boxch/translate/ru.dart';
import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': languageUS,
    'ru_RU': languageRU,
  };

}