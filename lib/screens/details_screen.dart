import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали Прогноза'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Первый контейнер с погодой и графиками
            Container(
              width: 343,
              height: 169,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Transform(
                      transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                      child: Container(
                        width: 169,
                        height: 343,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-0.98, -0.21),
                            end: Alignment(0.98, 0.21),
                            colors: [Colors.white, Colors.white.withOpacity(0)],
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 133.62,
                    top: 22,
                    child: Transform(
                      transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                      child: Container(
                        width: 33,
                        height: 75.75,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [Color(0xFF3C6FD1), Color(0xFF3C6FD1), Color(0xFF7CA8FF)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 146,
                    top: 31,
                    child: SizedBox(
                      width: 51,
                      height: 16,
                      child: Text(
                        'Сегодня',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 248.31,
                    top: 31,
                    child: SizedBox(
                      width: 67.34,
                      child: Text(
                        'Завтра',
                        style: TextStyle(
                          color: Color(0xFF363B64),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35,
                    top: 31,
                    child: SizedBox(
                      width: 67.34,
                      child: Text(
                        'Вчера',
                        style: TextStyle(
                          color: Color(0xFF363B64),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.83,
                    top: 79,
                    child: Container(
                      width: 307.23,
                      height: 75,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 69.44,
                            top: 22,
                            child: Container(
                              width: 29.46,
                              height: 27,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/29x27"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 277.77,
                            top: 22,
                            child: Container(
                              width: 29.46,
                              height: 28,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/29x28"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 22,
                            child: Container(
                              width: 29.46,
                              height: 28,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/29x28"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 208.33,
                            top: 22,
                            child: Container(
                              width: 29.46,
                              height: 28,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/29x28"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 138.88,
                            top: 22,
                            child: Container(
                              width: 29.46,
                              height: 28,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/29x28"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 1.05,
                            top: 0,
                            child: SizedBox(
                              width: 28.41,
                              child: Text(
                                '2 PM',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFA098AE),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 3.16,
                            top: 54,
                            child: SizedBox(
                              width: 24.20,
                              child: Text(
                                '28°',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF363B64),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          // Add more positions for other time and temperatures...
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Второй контейнер с текстом и изображением
            Container(
              width: 226,
              height: 158,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 106,
                    child: SizedBox(
                      width: 226,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Местами облачно\n',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 0.06,
                                letterSpacing: 0.30,
                              ),
                            ),
                            TextSpan(
                              text: 'Среда, 24 Октября 2024',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0.10,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 62,
                    top: 0,
                    child: Container(
                      width: 101,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://via.placeholder.com/101x90"),
                          fit: BoxFit.fill,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3F1F244B),
                            blurRadius: 28.59,
                            offset: Offset(0, 17.16),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
