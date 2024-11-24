import 'package:flutter/material.dart';
import 'package:aer/services/weather_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = 'Budapest';
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final data = await _weatherService.fetchWeather(_city);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weatherData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text('City: $_city', style: TextStyle(fontSize: 24)),
                  Divider(),
                  _currentWeather(),
                  Divider(),
                  _weatherForecast(),
                ],
              ),
            ),
    );
  }

  Widget _currentWeather() {
    final current = _weatherData!['current'];
    final sunrise = DateTime.fromMillisecondsSinceEpoch(current['sunrise'] * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(current['sunset'] * 1000);
    final avgTemp = (current['temp_min'] + current['temp_max']) / 2;
    final weatherType = current['weather'][0]['main'].toLowerCase();
    final weatherImages = {
      'clear': 'lib/images/cloud.png',
      'clouds': 'lib/images/clouds.png',
      'rain': 'lib/images/storm.png',
      'snow': 'lib/images/mist.png',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(weatherImages[weatherType] ?? 'lib/images/sun.png', width: 100, height: 100),
        Text('Min Temp: ${current['temp_min'] ?? 'N/A'}°C'),
        Text('Max Temp: ${current['temp_max'] ?? 'N/A'}°C'),
        Text('Humidity: ${current['humidity'] ?? 'N/A'}%'),
        Text('Weather: ${current['weather'][0]['description'] ?? 'N/A'}'),
        Text('Wind Speed: ${current['wind_speed'] ?? 'N/A'} m/s'),
        Text('Sunrise: ${DateFormat('hh:mm a').format(sunrise) ?? 'N/A'}'),
        Text('Sunset: ${DateFormat('hh:mm a').format(sunset) ?? 'N/A'}'),
        if (avgTemp < 7) Text('Recommended: Use winter tires'),
        if (current['uvi'] > 7) Text('Warning: High UV index'),
      ],
    );
  }

  Widget _weatherForecast() {
    final daily = _weatherData!['daily'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('7-Day Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
