import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'bdb58b681b1a2244364a8c448355e2f9';
  final String currentWeatherUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String hourlyForecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  final String dailyForecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  /// Получение текущей погоды по названию города
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http
          .get(Uri.parse('$currentWeatherUrl?q=$city&appid=$apiKey&units=metric&lang=ru'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Ошибка загрузки текущей погоды: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные о погоде: $e');
    }
  }

  /// Получение страны города
  Future<String> getCountryForCity(String city) async {
    try {
      // Запрашиваем данные о текущей погоде для города
      final data = await fetchWeather(city);

      // Извлекаем информацию о стране из данных
      final countryCode = data['sys']['country'];
      if (countryCode != null) {
        return _mapCountryCodeToName(countryCode);
      } else {
        throw Exception('Код страны не найден');
      }
    } catch (e) {
      return 'Неизвестно';
    }
  }

  /// Карта кодов стран в названия
  String _mapCountryCodeToName(String countryCode) {
    const countryMapping = {
      'KZ': 'Казахстан',
      'UZ': 'Узбекистан',
      'US': 'США',
      'RU': 'Россия',
      // Добавьте другие страны, если необходимо
    };
    return countryMapping[countryCode] ?? 'Неизвестно';
  }

  /// Получение почасового прогноза по названию города
  Future<List<Map<String, dynamic>>> fetchHourlyForecast(String city) async {
    try {
      // Получаем широту и долготу из данных текущей погоды
      final cityData = await fetchWeather(city);
      final latitude = cityData['coord']['lat'];
      final longitude = cityData['coord']['lon'];

      // Делаем запрос на почасовой прогноз
      final response = await http
          .get(Uri.parse('$hourlyForecastUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=ru'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Обрабатываем данные и возвращаем только нужные поля
        return List<Map<String, dynamic>>.from(data['list'].map((hour) => {
              'time': DateTime.fromMillisecondsSinceEpoch(hour['dt'] * 1000),
              'temperature': hour['main']['temp'],
              'icon': hour['weather'][0]['icon'],
              'weatherCondition': hour['weather'][0]['description'],
            }));
      } else {
        throw Exception('Ошибка загрузки почасового прогноза: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные о почасовом прогнозе: $e');
    }
  }

  /// Получение недельного прогноза по названию города
  Future<List<Map<String, dynamic>>> fetchWeeklyForecast(String city) async {
    try {
      // Получаем широту и долготу из данных текущей погоды
      final cityData = await fetchWeather(city);
      final latitude = cityData['coord']['lat'];
      final longitude = cityData['coord']['lon'];

      // Делаем запрос на 5-дневный прогноз (с данными по 3 часа)
      final response = await http
          .get(Uri.parse('$dailyForecastUrl?lat=$latitude&lon=$longitude&cnt=5&appid=$apiKey&units=metric&lang=ru'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Обрабатываем данные и возвращаем только нужные поля
        return List<Map<String, dynamic>>.from(data['list'].map((day) => {
              'day': DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000),
              'temperature': day['main']['temp'],
              'weatherCondition': day['weather'][0]['description'],
              'icon': day['weather'][0]['icon'],
            }));
      } else {
        throw Exception('Ошибка загрузки недельного прогноза: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные о недельном прогнозе: $e');
    }
  }

  /// Получение описания погоды в виде строки
  Future<String> getWeatherDescription(String city) async {
    try {
      final data = await fetchWeather(city);
      return data['weather'][0]['description'] ?? 'Нет данных';
    } catch (e) {
      return 'Не удалось загрузить данные о погоде: $e';
    }
  }

  /// Получение текущей температуры
  Future<double> getTemperature(String city) async {
    try {
      final data = await fetchWeather(city);
      return data['main']['temp'] ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Получение иконки текущей погоды
  Future<String> getWeatherIcon(String city) async {
    try {
      final data = await fetchWeather(city);
      return data['weather'][0]['icon'] ?? '01d';
    } catch (e) {
      return '01d';
    }
  }
}


