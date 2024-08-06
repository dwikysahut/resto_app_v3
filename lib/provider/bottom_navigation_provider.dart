import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  BottomNavigationProvider();

  int _selectedIndex = 0;

  //getter
  int get selectedIndex => _selectedIndex;

  void onSelectIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
