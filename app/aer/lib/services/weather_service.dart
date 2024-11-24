import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String? apiKey = dotenv.env['OPENWEATHER_API_KEY'];

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    if (apiKey == null) {
      throw Exception('API key is not loaded properly');
    }

    // Fallback coordinates for Budapest if location services are denied or there's an issue
    final fallbackCity = 'Budapest';

    final url = 'https://api.openweathermap.org/data/2.5/weather?q=${city.isEmpty ? fallbackCity : city}&appid=$apiKey&units=metric';
    print('Request URL: $url'); // Debug

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
