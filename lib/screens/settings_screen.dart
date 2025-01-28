import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/settings_provider.dart';
import 'package:weather_app/screens/about_screen.dart';
import 'package:weather_app/screens/version_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Настройки'),
        backgroundColor: Color(0xFF007AFF),
        elevation: 0,
      ),
      body: SingleChildScrollView( // Добавляем прокрутку
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Виджет для изменения температуры
            _settingsWidget(
              title: 'Единица измерения температуры',
              options: ['C', 'F'],
              selectedValue: settingsProvider.temperatureUnit,
              icon: Icon(Icons.thermostat_outlined),
              onChanged: (String newValue) {
                settingsProvider.updateTemperatureUnit(newValue);
              },
            ),
            SizedBox(height: 20),

            // Виджет для изменения скорости ветра
            _settingsWidget(
              title: 'Единица измерения ветра',
              options: ['Км/ч', 'Миль/ч', 'М/с'],
              selectedValue: settingsProvider.windSpeedUnit,
              icon: Icon(Icons.wind_power),
              onChanged: (String newValue) {
                settingsProvider.updateWindSpeedUnit(newValue);
              },
            ),
            SizedBox(height: 20),

            // Вкладки информации о приложении
            _infoWidget(
              context,
              title: 'Версия приложения',
              subtitle: '1.0.0',
              icon: Icon(Icons.info),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersionScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            _infoWidget(
              context,
              title: 'О приложении',
              subtitle: '',
              icon: Icon(Icons.info_outline),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            _infoWidget(
              context,
              title: 'Связь с разработчиком',
              subtitle: '',
              icon: Icon(Icons.contact_mail),
              onTap: () {
                _openDeveloperContact();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Виджет для изменения настроек
  Widget _settingsWidget({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Icon icon,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                icon,
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14, // Уменьшаем размер текста
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis, // Обрезаем длинный текст
                    maxLines: 1, // Ограничиваем текст одной строкой
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: selectedValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 14), // Уменьшаем размер текста
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue); // Вызываем callback только для ненулевых значений
              }
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14), // Уменьшаем размер текста
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Виджет для информации о приложении
  Widget _infoWidget(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Icon icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  // Открыть ссылку разработчика
  void _openDeveloperContact() {
    const url = 'https://telegram.me/assylnotass';
    launchUrl(Uri.parse(url));
  }
}
