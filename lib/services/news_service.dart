import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = '4cbca93684aa4029ba8ead5be4aff8c4';
  final String baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<dynamic>> fetchWeatherNews() async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=natural disaster&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}