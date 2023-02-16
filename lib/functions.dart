import 'package:intl/intl.dart';

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  var format = DateFormat('EEE, dd-MM-yyyy');
  return format.format(dateTime);
}
