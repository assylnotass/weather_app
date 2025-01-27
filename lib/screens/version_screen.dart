import 'package:flutter/material.dart';

class VersionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Версия приложения')),
      body: Center(
        child: Text(
          'Версия: 1.0.0\nПоследнее обновление: январь 2025',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
