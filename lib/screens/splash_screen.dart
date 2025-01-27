import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Переход к следующему экрану через 3 секунды
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Замените на ваш главный экран
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Градиентный фон
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF3C6FD1), Color(0xFF3C6FD1), Color(0xFF7CA8FF)],
                ),
              ),
            ),
          ),
          // Централизованный логотип и текст
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Логотип
                Container(
                  width: 120,
                  height: 118,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/logo.png"), // Логотип из папки assets
                      fit: BoxFit.fill,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F1F244B),
                        blurRadius: 25,
                        offset: Offset(0, 15),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Текст "Weather"
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 2),
                  child: Text(
                    'Weather',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.43,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Текст "Будьте всегда в курсе"
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 2),
                  child: Text(
                    'Будьте всегда в курсе',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.43,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
