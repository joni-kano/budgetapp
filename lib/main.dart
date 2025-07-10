import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/budget_tab.dart';
import 'screens/payments_tab.dart';
import 'screens/analysis_tab.dart';
import 'services/storage_service.dart';
import 'models/pending_payment.dart';
import 'models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF315172),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  @override
  _BudgetHomePageState createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> with TickerProviderStateMixin {
  double monthlyIncome = 0;
  double currentBalance = 0;
  List<PendingPayment> pendingPayments = [];
  List<Transaction> transactions = [];
  late TabController _tabController;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await _storageService.loadData();
    setState(() {
      monthlyIncome = data['monthlyIncome'] ?? 0;
      currentBalance = data['currentBalance'] ?? 0;
      pendingPayments = data['pendingPayments'] ?? [];
      transactions = data['transactions'] ?? [];
    });
  }

  Future<void> _saveData() async {
    await _storageService.saveData(
      monthlyIncome: monthlyIncome,
      currentBalance: currentBalance,
      pendingPayments: pendingPayments,
      transactions: transactions,
    );
  }

  void _updateIncome(double income) {
    setState(() {
      monthlyIncome = income;
    });
    _saveData();
  }

  void _addMoney(double amount) {
    setState(() {
      currentBalance += amount;
    });
    _saveData();
  }

  void _addPendingPayment(PendingPayment payment) {
    setState(() {
      pendingPayments.add(payment);
    });
    _saveData();
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions.insert(0, transaction);
      currentBalance -= transaction.amount;
    });
    _saveData();
  }

  void _markPaymentAsPaid(int index) {
    PendingPayment payment = pendingPayments[index];
    setState(() {
      transactions.insert(0, Transaction(
        name: payment.name,
        amount: payment.amount,
        category: payment.category,
        date: DateTime.now(),
        source: '',
      ));
      currentBalance -= payment.amount;
      pendingPayments.removeAt(index);
    });
    _saveData();
  }

  void _deletePayment(int index) {
    setState(() {
      pendingPayments.removeAt(index);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Budget Tracker'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: Icon(Icons.pie_chart,), text: 'Budget'),
            Tab(icon: Icon(Icons.payment,), text: 'Payments'),
            Tab(icon: Icon(Icons.analytics,), text: 'Analysis'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Current Balance Display
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.black87, size: 24),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'KES ${currentBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BudgetTab(
                  monthlyIncome: monthlyIncome,
                  currentBalance: currentBalance,
                  onIncomeUpdate: _updateIncome,
                  onAddMoney: _addMoney,
                  onAddTransaction: _addTransaction,
                  onAddPayment: _addPendingPayment,
                ),
                PaymentsTab(
                  pendingPayments: pendingPayments,
                  transactions: transactions,
                  onAddPayment: _addPendingPayment,
                  onMarkAsPaid: _markPaymentAsPaid,
                  onDeletePayment: _deletePayment,
                ),
                AnalysisTab(
                  monthlyIncome: monthlyIncome,
                  transactions: transactions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
