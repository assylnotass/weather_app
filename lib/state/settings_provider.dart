import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  String _temperatureUnit = 'C'; // C - Цельсий, F - Фаренгейт
  String _windSpeedUnit = 'Км/ч'; // Единицы измерения скорости ветра

  String get temperatureUnit => _temperatureUnit;
  String get windSpeedUnit => _windSpeedUnit;

  void updateTemperatureUnit(String unit) {
    _temperatureUnit = unit;
    notifyListeners();
  }

  void updateWindSpeedUnit(String unit) {
    _windSpeedUnit = unit;
    notifyListeners();
  }
}
