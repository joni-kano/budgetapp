import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pending_payment.dart';
import '../models/transaction.dart';
import '../widgets/allocation_item.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class BudgetTab extends StatefulWidget {
  final double monthlyIncome;
  final double currentBalance;
  final Function(double) onIncomeUpdate;
  final Function(double) onAddMoney;
  final Function(Transaction) onAddTransaction;
  final Function(PendingPayment) onAddPayment;
  

  const BudgetTab({
    Key? key,
    required this.monthlyIncome,
    required this.currentBalance,
    required this.onIncomeUpdate,
    required this.onAddMoney,
    required this.onAddTransaction,
    required this.onAddPayment,
  }) : super(key: key);

  @override
  _BudgetTabState createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  late TextEditingController _incomeController;

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController(
      text: widget.monthlyIncome == 0 ? '' : widget.monthlyIncome.toString(),
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIncomeSection(),
          SizedBox(height: 20),
          _buildAllocationSection(),
          SizedBox(height: 20),
          _buildQuickActionsSection(),
        ],
      ),
    );
  }

  Widget _buildIncomeSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Monthly Income',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Enter your monthly income',
                prefixText: 'KES ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                double income = double.tryParse(value) ?? 0;
                widget.onIncomeUpdate(income);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationSection() {
    if (widget.monthlyIncome == 0) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.pie_chart, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Enter your monthly income to see budget allocation',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Budget Allocation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            AllocationItem(
              title: 'Tithe/Charitable Giving',
              percentage: AppConstants.tithePercentage.toInt(),
              color: AppConstants.titheColor,
              icon: Icons.volunteer_activism,
              amount: widget.monthlyIncome * AppConstants.tithePercentage / 100,
            ),
            AllocationItem(
              title: 'Rent & Transport',
              percentage: AppConstants.rentTransportPercentage.toInt(),
              color: AppConstants.rentColor,
              icon: Icons.home,
              amount:
                  widget.monthlyIncome *
                  AppConstants.rentTransportPercentage /
                  100,
            ),
            AllocationItem(
              title: 'Investment & Savings',
              percentage: AppConstants.investmentPercentage.toInt(),
              color: AppConstants.investmentColor,
              icon: Icons.savings,
              amount:
                  widget.monthlyIncome *
                  AppConstants.investmentPercentage /
                  100,
            ),
            AllocationItem(
              title: 'Needs, Wants & Contributions',
              percentage: AppConstants.needsWantsPercentage.toInt(),
              color: AppConstants.needsColor,
              icon: Icons.shopping_cart,
              amount:
                  widget.monthlyIncome *
                  AppConstants.needsWantsPercentage /
                  100,
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            _buildInvestmentBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentBreakdown() {
    double investmentTotal =
        widget.monthlyIncome * AppConstants.investmentPercentage / 100;
    double savings = investmentTotal * AppConstants.savingsPercentage / 100;
    double crypto = investmentTotal * AppConstants.cryptoPercentage / 100;
    double mmf = investmentTotal * AppConstants.mmfPercentage / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investment & Savings Breakdown:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 12),
        _buildSubAllocationItem(
          'Traditional Savings',
          savings,
          Colors.green[300]!,
          Icons.account_balance,
        ),
        _buildSubAllocationItem(
          'Crypto/Digital Assets',
          crypto,
          Colors.amber[600]!,
          Icons.currency_bitcoin,
        ),
        _buildSubAllocationItem(
          'Money Market Funds',
          mmf,
          Colors.teal[400]!,
          Icons.trending_up,
        ),
      ],
    );
  }

  Widget _buildSubAllocationItem(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            Helpers.formatCurrency(amount),
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            // First row of buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add_circle),
                    label: Text('Add Expense'),
                    onPressed: () => _showAddExpenseDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.payment),
                    label: Text('Add Payment'),
                    onPressed: () => _showAddPaymentDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Second row - Add Money button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Money'),
                onPressed: () => _showAddMoneyDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMoneyDialog() {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Money'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Amount to Add',
                  prefixText: 'KES ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'This amount will be distributed according to your budget allocation:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              if (widget.monthlyIncome > 0) ...[
                Text('• ${AppConstants.tithePercentage.toInt()}% to Tithe/Charitable Giving'),
                Text('• ${AppConstants.rentTransportPercentage.toInt()}% to Rent & Transport'),
                Text('• ${AppConstants.investmentPercentage.toInt()}% to Investment & Savings'),
                Text('• ${AppConstants.needsWantsPercentage.toInt()}% to Needs, Wants & Contributions'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  double amount = double.parse(amountController.text);
                  widget.onAddMoney(amount);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Money added successfully')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExpenseDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedCategory = AppConstants.categories[1];
    // Default to Rent & Transport
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Expense Name',
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
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
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
                    items:
                        AppConstants.categories.map((category) {
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
                ],
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
                      widget.onAddTransaction(
                        Transaction(
                          name: nameController.text,
                          amount: double.parse(amountController.text),
                          category: selectedCategory,
                          date: DateTime.now(), 
                          source: '',
                        ),
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Expense added successfully')),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddPaymentDialog() {
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Payment Name',
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      widget.onAddPayment(
                        PendingPayment(
                          name: nameController.text,
                          amount: double.parse(amountController.text),
                          dueDate: dateController.text,
                          category: selectedCategory,
                        ),
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment added successfully')),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}