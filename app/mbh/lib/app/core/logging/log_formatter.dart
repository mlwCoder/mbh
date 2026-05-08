import 'package:intl/intl.dart';

class LogFormatter {
  const LogFormatter._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String formatTimestamp(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }
}
