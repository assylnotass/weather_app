import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class CitySearchScreen extends StatefulWidget {
  @override
  _CitySearchScreenState createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<String> _searchResults = [];

  void _searchCity() async {
    final city = _controller.text;
    if (city.isNotEmpty) {
      try {
        final data = await _weatherService.fetchWeather(city);
        setState(() {
          _searchResults = [data['name']]; // Добавляем найденный город
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Город не найден')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Поиск города')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Введите название города'),
            ),
          ),
          ElevatedButton(
            onPressed: _searchCity,
            child: Text('Найти город'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final cityName = _searchResults[index];
                return ListTile(
                  title: Text(cityName),
                  onTap: () => Navigator.pop(context, cityName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
