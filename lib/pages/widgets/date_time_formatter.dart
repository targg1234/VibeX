extension DateTimeFormatter on String? {
  String formatDateTime() {
    if (this == null || this!.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(this!);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
          '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return this!;
    }
  }
}
