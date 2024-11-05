import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

  String timeStr = DateFormat.jm().format(dateTime);

  if (date == today) {
    return 'Today at $timeStr';
  } else if (date == tomorrow) {
    return 'Tomorrow at $timeStr';
  } else {
    return DateFormat('MMM d, y').add_jm().format(dateTime);
  }
}