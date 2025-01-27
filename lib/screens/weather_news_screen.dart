import 'package:flutter/material.dart';
import 'dart:ui'; // Для использования BackdropFilter
import 'package:weather_app/services/news_service.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService newsService = NewsService();
  late Future<List<dynamic>> news;

  @override
  void initState() {
    super.initState();
    news = newsService.fetchWeatherNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Возвращает на предыдущий экран
          },
        ),
        title: Text('Новости'),
        backgroundColor: Color(0xFF007AFF),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки новостей'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Новостей не найдено'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article['urlToImage'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(
                          article['urlToImage'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article['title'] ?? 'Без заголовка',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363B64),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            article['description'] ?? 'Без описания',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFA098AE),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                article['source']['name'] ?? 'Неизвестный источник',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3C6FD1),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF363B64),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                article['publishedAt'] != null
                                    ? article['publishedAt'].substring(0, 10)
                                    : 'Неизвестная дата',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFA098AE),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}