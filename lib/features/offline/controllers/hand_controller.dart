import 'package:flutter/material.dart';

class HandController extends ChangeNotifier {
  final Set<String> _selected = {};

  bool isSelected(String id) => _selected.contains(id);

  void toggle(String id) {
    if (_selected.contains(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }

    notifyListeners();
  }

  void clear() {
    _selected.clear();
    notifyListeners();
  }

  List<String> get selectedCards => _selected.toList();
}
