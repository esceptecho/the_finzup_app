class Bill {
  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  bool? isPaid;

  Bill({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.isPaid,
  });
}