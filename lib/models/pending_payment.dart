class PendingPayment {
  final String name;
  final double amount;
  final String dueDate;

  PendingPayment({
    required this.name,
    required this.amount,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'dueDate': dueDate,
    };
  }

  factory PendingPayment.fromJson(Map<String, dynamic> json) {
    return PendingPayment(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: json['dueDate'] ?? '',
    );
  }
}