class Transaction {
  final String name;
  final double amount;
  final String category;
  final String source;
  final DateTime date;

  Transaction({
    required this.name,
    required this.amount,
    required this.source,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      date: DateTime.parse(json['date']), 
      source: json['source']??'',
    );
  }
}
