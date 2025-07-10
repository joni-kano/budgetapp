import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Budget Tracker';
  static const String appVersion = '1.0.0';
  
  // Budget allocation percentages
  static const double tithePercentage = 10;
  static const double rentTransportPercentage = 30;
  static const double investmentPercentage = 30;
  static const double needsWantsPercentage = 20;
  
  // Investment breakdown (within the 30%)
  static const double savingsPercentage = 20;
  static const double cryptoPercentage = 5;
  static const double mmfPercentage = 5;
  
  // Colors
  static const Color titheColor = Colors.purple;
  static const Color rentColor = Colors.orange;
  static const Color investmentColor = Colors.green;
  static const Color needsColor = Colors.blue;
  
  // Categories
  static const List<String> categories = [
    'Tithe/Charitable Giving',
    'Rent & Transport',
    'Investment & Savings',
    'Needs, Wants & Contributions',
  ];
}