import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/add_city_screen.dart';
import '../state/city_provider.dart';
import '../services/weather_service.dart';
import 'city_search_screen.dart';

class Sidebar extends StatelessWidget {
  final WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    final cityProvider = context.watch<CityProvider>();

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF3C6FD1), Color(0xFF3C6FD1), Color(0xFF7CA8FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхний блок с выбранной локацией
            Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: FutureBuilder<String>(
                future: weatherService.getCountryForCity(cityProvider.selectedCity),
                builder: (context, snapshot) {
                  final country = snapshot.data ?? 'Загрузка...';
                  return Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${cityProvider.selectedCity}, $country',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Элементы меню
            ListTile(
              leading: Icon(Icons.my_location, color: Colors.white),
              title: Text(
                'Моя локация',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/myLocation');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_location, color: Colors.white),
              title: Text(
                'Добавить город',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCityScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.article, color: Colors.white),
              title: Text(
                'Новости',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/weatherNews');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Настройки',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Divider(color: Colors.white.withOpacity(0.5)),
            // Список сохраненных городов
            Expanded(
              child: ListView.builder(
                itemCount: cityProvider.cities.length,
                itemBuilder: (context, index) {
                  final city = cityProvider.cities[index];
                  return FutureBuilder<String>(
                    future: weatherService.getCountryForCity(city),
                    builder: (context, snapshot) {
                      final country = snapshot.data ?? 'Загрузка...';
                      return ListTile(
                        leading: Icon(Icons.location_city, color: Colors.white),
                        title: Text(
                          '$city, $country',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          cityProvider.updateCity(city); // Обновляем текущий город
                          Navigator.pop(context); // Закрываем сайдбар
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
