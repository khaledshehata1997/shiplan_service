import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavbarProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  BottomNavbarProvider();
  factory BottomNavbarProvider.instance(
    BuildContext context, {
    bool listen = true,
  }) =>
      Provider.of<BottomNavbarProvider>(context, listen: listen);
  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
