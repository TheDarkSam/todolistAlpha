import 'package:flutter/material.dart';

class ThemeProviderService extends ChangeNotifier {
  bool _ativo = false;

  bool get themeStatus => _ativo;

  set themeStatus(value) {
    _ativo = value;
    notifyListeners();
  }
}
