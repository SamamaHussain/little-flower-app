import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:little_flower_app/models/weather_model.dart';

// Weather Service
class WeatherService {
  static const String _baseUrl = 'http://api.weatherapi.com/v1';
  static const String _apiKey =
      '35069112d2914a6dbf680324252611'; // Replace with your API key

  Future<Weather?> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/current.json?key=$_apiKey&q=$latitude,$longitude&aqi=no',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
