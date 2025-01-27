import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/news_service.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screens/sidebar.dart';
import 'package:provider/provider.dart';
import '../state/city_provider.dart';
import '../state/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final NewsService _newsService = NewsService();

  late Future<Map<String, dynamic>> currentWeather;
  late Future<List<dynamic>> hourlyForecast;
  late Future<List<dynamic>> weeklyForecast;
  late Future<dynamic> latestNews;

  @override
  void initState() {
    super.initState();
    _fetchData(context.read<CityProvider>().selectedCity);
  }

  void _fetchData(String city) {
    currentWeather = _weatherService.fetchWeather(city);
    hourlyForecast = _weatherService.fetchHourlyForecast(city);
    weeklyForecast = _weatherService.fetchWeeklyForecast(city);
    latestNews = _newsService.fetchWeatherNews().then((news) => news.first);
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
    final cityProvider = context.watch<CityProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    // Обновляем данные при изменении выбранного города
    _fetchData(cityProvider.selectedCity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Color(0xFF007AFF),
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),

            // Weather Card
            FutureBuilder<Map<String, dynamic>>(
              future: currentWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка загрузки данных о погоде'));
                }

                final weatherData = snapshot.data!;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Описание погоды на русском
                                Text(
                                  weatherData['weather'][0]['description']
                                      .toString()
                                      .replaceFirst(
                                          weatherData['weather'][0]
                                              ['description'][0],
                                          weatherData['weather'][0]
                                              ['description'][0]
                                              .toUpperCase()),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            if (weatherData['weather'][0]['icon'] != null)
                              Image.network(
                                'http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/location.png',
                              width: 16,
                              height: 16,
                            ),
                            Text(
                              cityProvider.selectedCity, // Используем выбранный город из провайдера
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      _convertTemperature(
                                          settingsProvider.temperatureUnit,
                                          weatherData['main']['temp']),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/humidity.png',
                                      width: 16,
                                      height: 16,
                                    ),
                                    Text(
                                      '${weatherData['main']['humidity']}%',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/wind.png',
                                      width: 16,
                                      height: 16,
                                    ),
                                    Text(
                                      _convertWindSpeed(
                                          settingsProvider.windSpeedUnit,
                                          (weatherData['wind']['speed'] as num).toDouble()),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            // Текст между виджетами с небольшим сдвигом вправо
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0), // Добавляем отступ слева
              child: Text(
                "Новости",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),


              // Latest News
              FutureBuilder<dynamic>(
                future: latestNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Ошибка загрузки новостей');
                  }

                  final news = snapshot.data;
                  final imageUrl = news != null && news['urlToImage'] != null
                      ? news['urlToImage']
                      : 'default_image_url_here'; // Укажите URL по умолчанию

                  // Заголовок новости и источник
                  final title = news != null ? news['title'] : 'Заголовок новости';
                  final source = news != null ? news['source']['name'] : 'Источник новости';
                  final date = news != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(news['publishedAt'])) : 'Дата новости';

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/weatherNews'),
                    child: Container(
                      height: 230,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ), ]
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 380,
                              height: 90,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 25,
                            top: 100,
                            child: SizedBox(
                              width: 300,
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: Color(0xFF363B64),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.30,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 215,
                            top: 170,
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                source,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFF363B64),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.30,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 25,
                            top: 170,
                            child: SizedBox(
                              width: 107.32,
                              child: Text(
                                date,
                                style: TextStyle(
                                  color: Color(0xFFA098AE),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

             SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0), // Добавляем отступ слева
                child: Text(
                  "Почасовый прогноз",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Почасовой прогноз
              Container(
                width: double.infinity,
                height: 150, // Увеличиваем высоту для рамки
                margin: EdgeInsets.symmetric(horizontal: 15), // Внешние отступы
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment(-0.98, -0.21),
                    end: Alignment(0.98, 0.21),
                    colors: [Colors.white, Colors.white.withOpacity(0)],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12), // Внутренние отступы для содержимого
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _weatherService.fetchHourlyForecast(cityProvider.selectedCity),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Ошибка загрузки данных прогноза'));
                      }

                      final hourlyData = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hourlyData.length,
                        itemBuilder: (context, index) {
                          final item = hourlyData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0), // Пробелы между элементами
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое внутри рамки
                              children: [
                                // Время
                                Text(
                                  '${item['time'].hour}:00',
                                  style: TextStyle(
                                    color: Color(0xFFA098AE),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Иконка погоды
                                Image.network(
                                  'https://openweathermap.org/img/wn/${item['icon']}@2x.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(height: 8),
                                // Температура
                                Text(
                                  _convertTemperature(settingsProvider.temperatureUnit, item['temperature']),
                                  style: TextStyle(
                                    color: Color(0xFF363B64),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),


        SizedBox(height: 20),

              Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0), // Добавляем отступ слева
              child: Text(
                "Недельный прогноз",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Недельный прогноз
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _weatherService.fetchWeeklyForecast(cityProvider.selectedCity),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка загрузки данных прогноза'));
                  }

                  final weeklyData = snapshot.data!;
                  return Column(
                    children: List.generate(weeklyData.length, (index) {
                      final day = weeklyData[index];
                      final dayOfWeek = DateFormat('EEEE', 'ru').format(
                        DateTime.now().add(Duration(days: index)),
                      );

                      return ListTile(
                        leading: Image.network(
                          'https://openweathermap.org/img/wn/${day['icon']}@2x.png',
                          width: 30,
                          height: 30,
                        ),
                        title: Text(
                          '$dayOfWeek: ${day['weatherCondition'] ?? 'Нет данных'}',
                          style: TextStyle(
                            color: Color(0xFF363B64),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Text(
                          _convertTemperature(settingsProvider.temperatureUnit, day['temperature']),
                          style: TextStyle(
                            color: Color(0xFF363B64),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0), // Добавляем отступ слева
              child: Text(
                "Моя локация",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // My Location
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Округленные углы
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  'Моя локация',
                  style: TextStyle(fontSize: 18, color: Color(0xFF3C6FD1)),
                ),
                subtitle: Text(context.watch<CityProvider>().selectedCity),
                onTap: () => Navigator.pushNamed(context, '/myLocation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
