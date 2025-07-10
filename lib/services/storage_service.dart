import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pending_payment.dart';
import '../models/transaction.dart';

class StorageService {
  static const String _incomeKey = 'monthlyIncome';
  static const String _paymentsKey = 'pendingPayments';
  static const String _transactionsKey = 'transactions';

  Future<Map<String, dynamic>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load income
    double monthlyIncome = prefs.getDouble(_incomeKey) ?? 0;
    
    // Load pending payments
    List<String> paymentsJson = prefs.getStringList(_paymentsKey) ?? [];
    List<PendingPayment> pendingPayments = paymentsJson
        .map((json) => PendingPayment.fromJson(jsonDecode(json)))
        .toList();
    
    // Load transactions
    List<String> transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    List<Transaction> transactions = transactionsJson
        .map((json) => Transaction.fromJson(jsonDecode(json)))
        .toList();

    return {
      'monthlyIncome': monthlyIncome,
      'pendingPayments': pendingPayments,
      'transactions': transactions,
    };
  }

  Future<void> saveData({
    required double monthlyIncome,
    required List<PendingPayment> pendingPayments,
    required List<Transaction> transactions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save income
    await prefs.setDouble(_incomeKey, monthlyIncome);
    
    // Save pending payments
    List<String> paymentsJson = pendingPayments
        .map((payment) => jsonEncode(payment.toJson()))
        .toList();
    await prefs.setStringList(_paymentsKey, paymentsJson);
    
    // Save transactions
    List<String> transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }
}