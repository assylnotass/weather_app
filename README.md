# weather_app

The application is intended to be used today using the openweathermap API. Provide API access to 3 types: 
1. For real-time weather forecast
2. For weather forecast with an interval of 3 hours
3. For a 5-day weather forecast

News feeds have also been added to provide news about natural disasters. However, in order to change the subject of the news, you just need to change the path lib/services/news_service.data in line 10: Uri.parse('base URL?q="your topic"&apiKey=$apiKey').

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
