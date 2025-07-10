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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 4,
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
      pendingPayments = data['pendingPayments'] ?? [];
      transactions = data['transactions'] ?? [];
    });
  }

  Future<void> _saveData() async {
    await _storageService.saveData(
      monthlyIncome: monthlyIncome,
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

  void _addPendingPayment(PendingPayment payment) {
    setState(() {
      pendingPayments.add(payment);
    });
    _saveData();
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions.insert(0, transaction);
    });
    _saveData();
  }

  void _markPaymentAsPaid(int index) {
    PendingPayment payment = pendingPayments[index];
    setState(() {
      transactions.insert(0, Transaction(
        name: payment.name,
        amount: payment.amount,
        category: 'Rent & Transport',
        date: DateTime.now(), 
        source: '',
      ));
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
      appBar: AppBar(
        title: Text('Budget Tracker'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.pie_chart), text: 'Budget'),
            Tab(icon: Icon(Icons.payment), text: 'Payments'),
            Tab(icon: Icon(Icons.analytics), text: 'Analysis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BudgetTab(
            monthlyIncome: monthlyIncome,
            onIncomeUpdate: _updateIncome,
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
    );
  }
}