import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  final date = timestamp.toDate();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) {
    return 'Last updated - Today, ${DateFormat('hh:mm a').format(date)}';
  } else {
    return 'Last updated - ${DateFormat('dd/MM/yyyy hh:mm a').format(date)}';
  }
}
