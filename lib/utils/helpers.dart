import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class Helpers {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_KE',
      symbol: 'KES ',
      decimalDigits: 2,
    ).format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Tithe/Charitable Giving':
        return Icons.volunteer_activism;
      case 'Rent & Transport':
        return Icons.home;
      case 'Investment & Savings':
        return Icons.savings;
      case 'Needs, Wants & Contributions':
        return Icons.shopping_cart;
      default:
        return Icons.category;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Tithe/Charitable Giving':
        return AppConstants.titheColor;
      case 'Rent & Transport':
        return AppConstants.rentColor;
      case 'Investment & Savings':
        return AppConstants.investmentColor;
      case 'Needs, Wants & Contributions':
        return AppConstants.needsColor;
      default:
        return Colors.grey;
    }
  }
}