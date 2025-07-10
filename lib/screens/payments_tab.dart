import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pending_payment.dart';
import '../models/transaction.dart';
import '../widgets/pending_payment_item.dart';
import '../widgets/transaction_item.dart';
import '../utils/constants.dart';

class PaymentsTab extends StatelessWidget {
  final List<PendingPayment> pendingPayments;
  final List<Transaction> transactions;
  final Function(PendingPayment) onAddPayment;
  final Function(int) onMarkAsPaid;
  final Function(int) onDeletePayment;

  const PaymentsTab({
    Key? key,
    required this.pendingPayments,
    required this.transactions,
    required this.onAddPayment,
    required this.onMarkAsPaid,
    required this.onDeletePayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPendingPaymentsSection(context),
          SizedBox(height: 20),
          _buildRecentTransactionsSection(),
        ],
      ),
    );
  }

  Widget _buildPendingPaymentsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Pending Payments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Payment'),
                  onPressed: () => _showAddPaymentDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (pendingPayments.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No pending payments',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add a payment to keep track of your upcoming expenses',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: pendingPayments.asMap().entries.map((entry) {
                  int index = entry.key;
                  PendingPayment payment = entry.value;
                  return PendingPaymentItem(
                    payment: payment,
                    onMarkAsPaid: () => onMarkAsPaid(index),
                    onDelete: () => onDeletePayment(index),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSection() {
    List<Transaction> recentTransactions = transactions.take(10).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (recentTransactions.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your recent transactions will appear here',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: recentTransactions.map((transaction) {
                  return TransactionItem(transaction: transaction);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    String selectedCategory = AppConstants.categories[1]; // Default to Rent & Transport
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Pending Payment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Payment Name',
                        hintText: 'e.g., Rent, Electricity Bill',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: 'KES ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: AppConstants.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: 'Due Date (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'e.g., 15th Jan 2025',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      onAddPayment(
                        PendingPayment(
                          name: nameController.text,
                          amount: double.parse(amountController.text),
                          dueDate: dateController.text,
                          category: selectedCategory,
                        ),
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Payment added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text('Add Payment'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}