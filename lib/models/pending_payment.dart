class PendingPayment {
  final String name;
  final double amount;
  final String dueDate;
  final String category; // New field for category

  PendingPayment({
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'dueDate': dueDate,
      'category': category,
    };
  }

  factory PendingPayment.fromJson(Map<String, dynamic> json) {
    return PendingPayment(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: json['dueDate'] ?? '',
      category: json['category'] ?? 'Rent & Transport', // Default category
    );
  }
}