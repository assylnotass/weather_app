import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../state/city_provider.dart';
import '../state/settings_provider.dart';
import 'package:intl/intl.dart';

class MyLocationScreen extends StatefulWidget {
  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  final WeatherService _weatherService = WeatherService();

  late Future<Map<String, dynamic>> currentWeather;
  late Future<List<Map<String, dynamic>>> hourlyForecast;

  int selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    final selectedCity = context.read<CityProvider>().selectedCity;
    _fetchWeatherData(selectedCity);
  }

  void _fetchWeatherData(String city) {
    currentWeather = _weatherService.fetchWeather(city);
    hourlyForecast = _weatherService.fetchHourlyForecast(city);
  }

  String _convertTemperature(String unit, double temperature) {
    if (unit == 'F') {
      return '${(temperature * 9 / 5 + 32).toStringAsFixed(1)}°F';
    }
    return '${temperature.toStringAsFixed(1)}°C';
  }

  String _convertWindSpeed(String unit, double speed) {
    switch (unit) {
      case 'Миль/ч':
        return '${(speed * 0.621371).toStringAsFixed(1)} миль/ч';
      case 'М/с':
        return '${speed.toStringAsFixed(1)} м/с';
      default: // Км/ч
        return '${(speed * 3.6).toStringAsFixed(1)} км/ч';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = context.watch<CityProvider>().selectedCity;
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      appBar: AppBar(
        title: Text("Мое местоположение"),
        backgroundColor: Color(0xFF007AFF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Верхний виджет: текущая погода
            FutureBuilder<Map<String, dynamic>>(
              future: currentWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка загрузки данных'));
                }

                final weatherData = snapshot.data!;
                return Container(
                  width: double.infinity,
                  height: 85,
                  decoration: BoxDecoration(
                    color: Color(0xFF3C6FD1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 13,
                        top: 14,
                        child: Image.network(
                          'http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$selectedCity, ${weatherData['sys']['country']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              weatherData['weather'][0]['description'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Ощущается как ${_convertTemperature(settingsProvider.temperatureUnit, weatherData['main']['feels_like'])}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 240,
                        top: 15,
                        child: Text(
                          _convertTemperature(settingsProvider.temperatureUnit, weatherData['main']['temp']),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Информация о погоде",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

// Прогноз погоды (почасовой, с выбором дней)
FutureBuilder<List<Map<String, dynamic>>>(
  future: hourlyForecast,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Ошибка загрузки прогноза'));
    }

    final forecastData = snapshot.data!;
    final dayGroups = _groupForecastByDay(forecastData);
    final settingsProvider = context.watch<SettingsProvider>();

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 300), // Ограничиваем высоту
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Горизонтальная прокрутка для дат
          Container(
            height: 50, // Высота контейнера для дат
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dayGroups.keys.length,
              itemBuilder: (context, index) {
                final day = dayGroups.keys.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16), // Пробелы между датами
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: index == selectedDayIndex
                          ? Colors.blue
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: index == selectedDayIndex
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // Почасовой прогноз для выбранного дня
          Expanded(
            child: ListView(
              children: dayGroups.values
                  .elementAt(selectedDayIndex)
                  .map((forecast) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Время
                          Text(_formatDateTime(forecast['time'])),
                          // Иконка погоды
                          Image.network(
                            'http://openweathermap.org/img/wn/${forecast['icon']}@2x.png',
                            width: 30,
                            height: 30,
                          ),
                          // Температура
                          Text(
                            _convertTemperature(settingsProvider.temperatureUnit, forecast['temperature']),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  },
),


            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Состояние ветра",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Виджет ветра
            FutureBuilder<Map<String, dynamic>>(
              future: currentWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка загрузки данных ветра'));
                }

                final weatherData = snapshot.data!;
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.air, size: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Скорость ветра: ${_convertWindSpeed(settingsProvider.windSpeedUnit, (weatherData['wind']['speed'] as num).toDouble())}",
                          ),
                          Text("Порывы ветра: ${weatherData['wind']['gust'] ?? 'N/A'}"),
                          Text("Направление ветра: ${weatherData['wind']['deg']}°"),
                          Text("Давление: ${weatherData['main']['pressure']} гПа"),
                          Text("Влажность: ${weatherData['main']['humidity']}%"),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

                        SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Состояние солнца",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

// Виджет солнца
FutureBuilder<Map<String, dynamic>>(
  future: currentWeather,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Ошибка загрузки данных солнца'));
    }

    final weatherData = snapshot.data!;
    final settingsProvider = context.watch<SettingsProvider>();

    // Конвертация видимости
    String _convertVisibility(int visibilityInMeters) {
      if (settingsProvider.windSpeedUnit == 'Миль/ч') {
        return '${(visibilityInMeters / 1609.34).toStringAsFixed(1)} миль';
      }
      // По умолчанию километры
      return '${(visibilityInMeters / 1000).toStringAsFixed(1)} км';
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.wb_sunny, size: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Восход: ${_formatTime(weatherData['sys']['sunrise'])}"),
              Text("Закат: ${_formatTime(weatherData['sys']['sunset'])}"),
              Text("УФ индекс: ${weatherData['uvi'] ?? 'N/A'}"),
              Text("Видимость: ${_convertVisibility(weatherData['visibility'])}"),
            ],
          ),
        ],
      ),
    );
  },
),


          ],
        ),
      ),
    );
    
  }



  // Группировка прогноза по дням
  Map<String, List<Map<String, dynamic>>> _groupForecastByDay(
      List<Map<String, dynamic>> forecast) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final dateFormat = DateFormat('yyyy-MM-dd');
    for (final entry in forecast) {
      final day = dateFormat.format(entry['time']);
      grouped.putIfAbsent(day, () => []).add(entry);
    }
    return grouped;
  }

  // Форматирование времени
  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  // Форматирование времени (восход, закат)
  String _formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
