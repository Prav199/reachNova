class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });
}
