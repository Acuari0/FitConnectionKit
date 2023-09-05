import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../pages/dashboard_page.dart';

import 'dashboard_page_model.dart';

class HomeModel extends ChangeNotifier {
  int currentIndex = 0;
  final screens = [
    ChangeNotifierProvider(
      create: (_) => DashboardPageModel(),
      child: const DashboardPage(),
    ),
  ];

  void setCurrentIndex(int val) {
    currentIndex = val;
    notifyListeners();
  }
}
