// // main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Budget Tracker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: BudgetHomePage(),
//     );
//   }
// }

// class BudgetHomePage extends StatefulWidget {
//   @override
//   _BudgetHomePageState createState() => _BudgetHomePageState();
// }

// class _BudgetHomePageState extends State<BudgetHomePage> with TickerProviderStateMixin {
//   double monthlyIncome = 0;
//   List<PendingPayment> pendingPayments = [];
//   List<Transaction> transactions = [];
//   late TabController _tabController;
  
//   TextEditingController incomeController = TextEditingController();
//   TextEditingController paymentNameController = TextEditingController();
//   TextEditingController paymentAmountController = TextEditingController();
//   TextEditingController paymentDateController = TextEditingController();
//   TextEditingController expenseNameController = TextEditingController();
//   TextEditingController expenseAmountController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   // Data persistence methods
//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
    
//     setState(() {
//       monthlyIncome = prefs.getDouble('monthlyIncome') ?? 0;
//       incomeController.text = monthlyIncome == 0 ? '' : monthlyIncome.toString();
      
//       // Load pending payments
//       final paymentsJson = prefs.getStringList('pendingPayments') ?? [];
//       pendingPayments = paymentsJson.map((json) => PendingPayment.fromJson(jsonDecode(json))).toList();
      
//       // Load transactions
//       final transactionsJson = prefs.getStringList('transactions') ?? [];
//       transactions = transactionsJson.map((json) => Transaction.fromJson(jsonDecode(json))).toList();
//     });
//   }

//   Future<void> _saveData() async {
//     final prefs = await SharedPreferences.getInstance();
    
//     await prefs.setDouble('monthlyIncome', monthlyIncome);
    
//     // Save pending payments
//     final paymentsJson = pendingPayments.map((payment) => jsonEncode(payment.toJson())).toList();
//     await prefs.setStringList('pendingPayments', paymentsJson);
    
//     // Save transactions
//     final transactionsJson = transactions.map((transaction) => jsonEncode(transaction.toJson())).toList();
//     await prefs.setStringList('transactions', transactionsJson);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Budget Tracker'),
//         backgroundColor: Colors.blue[700],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(icon: Icon(Icons.home), text: 'Budget'),
//             Tab(icon: Icon(Icons.payment), text: 'Payments'),
//             Tab(icon: Icon(Icons.analytics), text: 'Analysis'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildBudgetTab(),
//           _buildPaymentsTab(),
//           _buildAnalysisTab(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBudgetTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildIncomeSection(),
//           SizedBox(height: 20),
//           _buildAllocationSection(),
//           SizedBox(height: 20),
//           _buildQuickActionsSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentsTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildPendingPaymentsSection(),
//           SizedBox(height: 20),
//           _buildRecentTransactionsSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnalysisTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSpendingOverview(),
//           SizedBox(height: 20),
//           _buildCategoryBreakdown(),
//           SizedBox(height: 20),
//           _buildMonthlyTrends(),
//         ],
//       ),
//     );
//   }

//   Widget _buildIncomeSection() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Monthly Income',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: incomeController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Enter your monthly income',
//                 prefixText: 'KES ',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   monthlyIncome = double.tryParse(value) ?? 0;
//                 });
//                 _saveData();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAllocationSection() {
//     if (monthlyIncome == 0) {
//       return Card(
//         elevation: 4,
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Enter your monthly income to see budget allocation',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//         ),
//       );
//     }

//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Budget Allocation',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 15),
//             _buildAllocationItem(
//               'Tithe/Charitable Giving',
//               10,
//               Colors.purple,
//               Icons.volunteer_activism,
//             ),
//             _buildAllocationItem(
//               'Rent & Transport',
//               30,
//               Colors.orange,
//               Icons.home,
//             ),
//             _buildAllocationItem(
//               'Investment & Savings',
//               30,
//               Colors.green,
//               Icons.savings,
//             ),
//             _buildAllocationItem(
//               'Needs, Wants & Contributions',
//               20,
//               Colors.blue,
//               Icons.shopping_cart,
//             ),
//             SizedBox(height: 10),
//             Divider(),
//             _buildInvestmentBreakdown(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAllocationItem(String title, int percentage, Color color, IconData icon) {
//     double amount = monthlyIncome * percentage / 100;
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   '$percentage% - KES ${amount.toStringAsFixed(2)}',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInvestmentBreakdown() {
//     double investmentTotal = monthlyIncome * 0.30;
//     double savings = investmentTotal * 0.20 / 0.30;
//     double crypto = investmentTotal * 0.05 / 0.30;
//     double mmf = investmentTotal * 0.05 / 0.30;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Investment & Savings Breakdown:',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         SizedBox(height: 10),
//         _buildSubAllocationItem('Traditional Savings', savings, Colors.green[300]!),
//         _buildSubAllocationItem('Crypto/Digital Assets', crypto, Colors.amber[600]!),
//         _buildSubAllocationItem('Money Market Funds', mmf, Colors.teal[400]!),
//       ],
//     );
//   }

//   Widget _buildSubAllocationItem(String title, double amount, Color color) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 3),
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 12,
//             height: 12,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(title),
//           ),
//           Text(
//             'KES ${amount.toStringAsFixed(2)}',
//             style: TextStyle(fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionsSection() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Quick Actions',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 15),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: Icon(Icons.add_circle),
//                     label: Text('Add Expense'),
//                     onPressed: _showAddExpenseDialog,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red[400],
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: Icon(Icons.payment),
//                     label: Text('Add Payment'),
//                     onPressed: _showAddPaymentDialog,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[400],
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPendingPaymentsSection() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Pending Payments',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: _showAddPaymentDialog,
//                   child: Text('Add Payment'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 15),
//             if (pendingPayments.isEmpty)
//               Center(
//                 child: Text(
//                   'No pending payments',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: pendingPayments.length,
//                 itemBuilder: (context, index) {
//                   return _buildPendingPaymentItem(pendingPayments[index], index);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPendingPaymentItem(PendingPayment payment, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey[300]!),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   payment.name,
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   'KES ${payment.amount.toStringAsFixed(2)}',
//                   style: TextStyle(color: Colors.red[600]),
//                 ),
//                 if (payment.dueDate.isNotEmpty)
//                   Text(
//                     'Due: ${payment.dueDate}',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                   ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.check_circle, color: Colors.green),
//             onPressed: () => _markPaymentAsPaid(index),
//           ),
//           IconButton(
//             icon: Icon(Icons.delete, color: Colors.red),
//             onPressed: () => _deletePayment(index),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentTransactionsSection() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Recent Transactions',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 15),
//             if (transactions.isEmpty)
//               Center(
//                 child: Text(
//                   'No transactions yet',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: transactions.take(5).length,
//                 itemBuilder: (context, index) {
//                   return _buildTransactionItem(transactions[index]);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTransactionItem(Transaction transaction) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey[300]!),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             _getCategoryIcon(transaction.category),
//             color: _getCategoryColor(transaction.category),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   transaction.name,
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   transaction.category,
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'KES ${transaction.amount.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.red[600],
//                 ),
//               ),
//               Text(
//                 DateFormat('MMM dd').format(transaction.date),
//                 style: TextStyle(color: Colors.grey[600], fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSpendingOverview() {
//     double totalSpent = transactions.fold(0, (sum, transaction) => sum + transaction.amount);
//     double remainingBudget = monthlyIncome - totalSpent;

//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Monthly Overview',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildOverviewItem('Income', monthlyIncome, Colors.green),
//                 _buildOverviewItem('Spent', totalSpent, Colors.red),
//                 _buildOverviewItem('Remaining', remainingBudget, Colors.blue),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOverviewItem(String label, double amount, Color color) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(color: Colors.grey[600], fontSize: 14),
//         ),
//         SizedBox(height: 5),
//         Text(
//           'KES ${amount.toStringAsFixed(0)}',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryBreakdown() {
//     if (transactions.isEmpty) {
//       return Card(
//         elevation: 4,
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Category Breakdown',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   'No transactions to analyze',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Map<String, double> categoryTotals = {};
//     for (var transaction in transactions) {
//       categoryTotals[transaction.category] = 
//           (categoryTotals[transaction.category] ?? 0) + transaction.amount;
//     }

//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Category Breakdown',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 15),
//             Container(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sections: categoryTotals.entries.map((entry) {
//                     return PieChartSectionData(
//                       value: entry.value,
//                       title: '${entry.key}\n${(entry.value / categoryTotals.values.fold(0, (a, b) => a + b) * 100).toStringAsFixed(1)}%',
//                       color: _getCategoryColor(entry.key),
//                       radius: 80,
//                       titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMonthlyTrends() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Monthly Trends',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 15),
//             Container(
//               height: 200,
//               child: transactions.isEmpty
//                   ? Center(
//                       child: Text(
//                         'No data to display trends',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     )
//                   : LineChart(
//                       LineChartData(
//                         gridData: FlGridData(show: false),
//                         titlesData: FlTitlesData(show: false),
//                         borderData: FlBorderData(show: false),
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: _getMonthlySpots(),
//                             isCurved: true,
//                             color: Colors.blue,
//                             barWidth: 3,
//                             dotData: FlDotData(show: false),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<FlSpot> _getMonthlySpots() {
//     if (transactions.isEmpty) return [];
    
//     Map<int, double> monthlyTotals = {};
//     for (var transaction in transactions) {
//       int month = transaction.date.month;
//       monthlyTotals[month] = (monthlyTotals[month] ?? 0) + transaction.amount;
//     }

//     return monthlyTotals.entries
//         .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
//         .toList();
//   }

//   void _showAddPaymentDialog() {
//     paymentNameController.clear();
//     paymentAmountController.clear();
//     paymentDateController.clear();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Pending Payment'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: paymentNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Payment Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: paymentAmountController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Amount',
//                   prefixText: 'KES ',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: paymentDateController,
//                 decoration: InputDecoration(
//                   labelText: 'Due Date (Optional)',
//                   border: OutlineInputBorder(),
//                   hintText: 'e.g., 15th Jan 2025',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (paymentNameController.text.isNotEmpty &&
//                     paymentAmountController.text.isNotEmpty) {
//                   setState(() {
//                     pendingPayments.add(PendingPayment(
//                       name: paymentNameController.text,
//                       amount: double.parse(paymentAmountController.text),
//                       dueDate: paymentDateController.text,
//                     ));
//                   });
//                   _saveData();
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddExpenseDialog() {
//     expenseNameController.clear();
//     expenseAmountController.clear();
//     String selectedCategory = 'Rent & Transport';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Add Expense'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: expenseNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Expense Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   TextField(
//                     controller: expenseAmountController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Amount',
//                       prefixText: 'KES ',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   DropdownButtonFormField<String>(
//                     value: selectedCategory,
//                     decoration: InputDecoration(
//                       labelText: 'Category',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: [
//                       'Tithe/Charitable Giving',
//                       'Rent & Transport',
//                       'Investment & Savings',
//                       'Needs, Wants & Contributions',
//                     ].map((category) {
//                       return DropdownMenuItem(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedCategory = value!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (expenseNameController.text.isNotEmpty &&
//                         expenseAmountController.text.isNotEmpty) {
//                       this.setState(() {
//                         transactions.add(Transaction(
//                           name: expenseNameController.text,
//                           amount: double.parse(expenseAmountController.text),
//                           category: selectedCategory,
//                           date: DateTime.now(),
//                         ));
//                       });
//                       _saveData();
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text('Add'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _markPaymentAsPaid(int index) {
//     PendingPayment payment = pendingPayments[index];
//     setState(() {
//       transactions.add(Transaction(
//         name: payment.name,
//         amount: payment.amount,
//         category: 'Rent & Transport', // Default category
//         date: DateTime.now(),
//       ));
//       pendingPayments.removeAt(index);
//     });
//     _saveData();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment marked as paid and added to transactions')),
//     );
//   }

//   void _deletePayment(int index) {
//     setState(() {
//       pendingPayments.removeAt(index);
//     });
//     _saveData();
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category) {
//       case 'Tithe/Charitable Giving':
//         return Icons.volunteer_activism;
//       case 'Rent & Transport':
//         return Icons.home;
//       case 'Investment & Savings':
//         return Icons.savings;
//       case 'Needs, Wants & Contributions':
//         return Icons.shopping_cart;
//       default:
//         return Icons.category;
//     }
//   }

//   Color _getCategoryColor(String category) {
//     switch (category) {
//       case 'Tithe/Charitable Giving':
//         return Colors.purple;
//       case 'Rent & Transport':
//         return Colors.orange;
//       case 'Investment & Savings':
//         return Colors.green;
//       case 'Needs, Wants & Contributions':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// class PendingPayment {
//   final String name;
//   final double amount;
//   final String dueDate;

//   PendingPayment({
//     required this.name,
//     required this.amount,
//     required this.dueDate,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'amount': amount,
//       'dueDate': dueDate,
//     };
//   }

//   factory PendingPayment.fromJson(Map<String, dynamic> json) {
//     return PendingPayment(
//       name: json['name'],
//       amount: json['amount'],
//       dueDate: json['dueDate'],
//     );
//   }
// }

// class Transaction {
//   final String name;
//   final double amount;
//   final String category;
//   final DateTime date;

//   Transaction({
//     required this.name,
//     required this.amount,
//     required this.category,
//     required this.date,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'amount': amount,
//       'category': category,
//       'date': date.toIso8601String(),
//     };
//   }

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       name: json['name'],
//       amount: json['amount'],
//       category: json['category'],
//       date: DateTime.parse(json['date']),
//     );
//   }
// }