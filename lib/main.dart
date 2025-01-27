import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/city_search_screen.dart';
import 'screens/my_location_screen.dart';
import 'screens/add_city_screen.dart';
import 'screens/weather_news_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/details_screen.dart';
import 'services/weather_service.dart';
import 'state/city_provider.dart'; // Новый провайдер
import 'state/settings_provider.dart'; // Новый провайдер

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null); // Инициализация локализации для русского языка
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CityProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()), // Подключение SettingsProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/citySearch': (context) => CitySearchScreen(),
        '/myLocation': (context) => MyLocationScreen(),
        '/addCity': (context) => AddCityScreen(),
        '/weatherNews': (context) => NewsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/details': (context) => DetailsScreen(),
      },
    );
  }
}
