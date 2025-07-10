import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class AnalysisTab extends StatelessWidget {
  final double monthlyIncome;
  final List<Transaction> transactions;

  const AnalysisTab({
    Key? key,
    required this.monthlyIncome,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpendingOverview(),
          SizedBox(height: 20),
          _buildCategoryBreakdown(),
          SizedBox(height: 20),
          _buildBudgetProgress(),
          SizedBox(height: 20),
          _buildSpendingTrends(),
        ],
      ),
    );
  }

  Widget _buildSpendingOverview() {
    double totalSpent = transactions.fold(0, (sum, transaction) => sum + transaction.amount);
    double remainingBudget = monthlyIncome - totalSpent;
    double spentPercentage = monthlyIncome > 0 ? (totalSpent / monthlyIncome) * 100 : 0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Monthly Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard(
                    'Income',
                    monthlyIncome,
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Spent',
                    totalSpent,
                    Colors.red,
                    Icons.trending_down,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Remaining',
                    remainingBudget,
                    remainingBudget >= 0 ? Colors.blue : Colors.red,
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: spentPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                spentPercentage > 100 ? Colors.red : Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${spentPercentage.toStringAsFixed(1)}% of budget used',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          FittedBox(
            child: Text(
              Helpers.formatCurrency(amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    if (transactions.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.pie_chart,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No spending data to analyze',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add some expenses to see category breakdown',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      categoryTotals[transaction.category] = 
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    double totalSpent = categoryTotals.values.fold(0, (a, b) => a + b);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Category Breakdown',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries.map((entry) {
                    double percentage = (entry.value / totalSpent) * 100;
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${percentage.toStringAsFixed(1)}%',
                      color: Helpers.getCategoryColor(entry.key),
                      radius: 80,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            SizedBox(height: 16),
            ...categoryTotals.entries.map((entry) {
              double percentage = (entry.value / totalSpent) * 100;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Helpers.getCategoryColor(entry.key),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}% • ${Helpers.formatCurrency(entry.value)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetProgress() {
    Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      categoryTotals[transaction.category] = 
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.track_changes, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Budget vs Actual',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildBudgetProgressItem(
              'Tithe/Charitable Giving',
              monthlyIncome * AppConstants.tithePercentage / 100,
              categoryTotals['Tithe/Charitable Giving'] ?? 0,
              AppConstants.titheColor,
            ),
            _buildBudgetProgressItem(
              'Rent & Transport',
              monthlyIncome * AppConstants.rentTransportPercentage / 100,
              categoryTotals['Rent & Transport'] ?? 0,
              AppConstants.rentColor,
            ),
            _buildBudgetProgressItem(
              'Investment & Savings',
              monthlyIncome * AppConstants.investmentPercentage / 100,
              categoryTotals['Investment & Savings'] ?? 0,
              AppConstants.investmentColor,
            ),
            _buildBudgetProgressItem(
              'Needs, Wants & Contributions',
              monthlyIncome * AppConstants.needsWantsPercentage / 100,
              categoryTotals['Needs, Wants & Contributions'] ?? 0,
              AppConstants.needsColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetProgressItem(String category, double budgeted, double actual, Color color) {
    double percentage = budgeted > 0 ? (actual / budgeted) : 0;
    bool isOverBudget = actual > budgeted;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                '${Helpers.formatCurrency(actual)} / ${Helpers.formatCurrency(budgeted)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isOverBudget ? Colors.red : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage > 1 ? 1 : percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget ? Colors.red : color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% used${isOverBudget ? ' (Over budget!)' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: isOverBudget ? Colors.red : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingTrends() {
    if (transactions.length < 2) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.trending_up,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'Not enough data for trends',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add more transactions to see spending trends',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
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
                Icon(Icons.trending_up, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Spending Trends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpendingSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Daily spending over the last ${transactions.length} transactions',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getSpendingSpots() {
    if (transactions.isEmpty) return [];
    
    // Group transactions by day and sum amounts
    Map<DateTime, double> dailySpending = {};
    for (var transaction in transactions) {
      DateTime day = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      dailySpending[day] = (dailySpending[day] ?? 0) + transaction.amount;
    }

    // Sort by date and create spots
    List<MapEntry<DateTime, double>> sortedEntries = dailySpending.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }
}