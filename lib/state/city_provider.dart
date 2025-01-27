import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityProvider extends ChangeNotifier {
  String _selectedCity = 'Астана'; // Город по умолчанию
  List<String> _cities = ['Астана']; // Города по умолчанию

  String get selectedCity => _selectedCity;
  List<String> get cities => _cities;

  CityProvider() {
    _loadCities(); // Загружаем данные при инициализации
  }

  // Сохранение выбранного города
  void updateCity(String city) async {
    _selectedCity = city;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCity', city); // Сохраняем в SharedPreferences
  }

  // Добавление нового города
  void addCity(String city) async {
    if (!_cities.contains(city)) {
      _cities.add(city);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('cities', _cities); // Сохраняем список городов
    }
  }

  // Удаление города
  void removeCity(String city) async {
    _cities.remove(city);
    if (_selectedCity == city && _cities.isNotEmpty) {
      _selectedCity = _cities.first; // Выбираем первый город из списка
    } else if (_cities.isEmpty) {
      _selectedCity = 'Астана'; // Возвращаемся к городу по умолчанию
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', _cities);
    await prefs.setString('selectedCity', _selectedCity);
  }

  // Загрузка данных из SharedPreferences
  Future<void> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCity = prefs.getString('selectedCity') ?? 'Астана';
    _cities = prefs.getStringList('cities') ?? ['Астана'];
    notifyListeners();
  }
}