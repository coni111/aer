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
  String? _error;

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
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _error != null
          ? Center(child: Text('Error: $_error'))
          : _weatherData == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('City: $_city', style: TextStyle(fontSize: 24)),
                      Divider(),
                      _currentWeather(),
                    ],
                  ),
                ),
    );
  }

  Widget _currentWeather() {
    final main = _weatherData!['main'];
    final weather = _weatherData!['weather'][0];
    final wind = _weatherData!['wind'];
    final sys = _weatherData!['sys'];
    final sunrise = DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Temperature: ${main['temp']}°C'),
        Text('Min Temp: ${main['temp_min']}°C'),
        Text('Max Temp: ${main['temp_max']}°C'),
        Text('Humidity: ${main['humidity']}%'),
        Text('Weather: ${weather['description']}'),
        Text('Wind Speed: ${wind['speed']} m/s'),
        Text('Sunrise: ${DateFormat('hh:mm a').format(sunrise)}'),
        Text('Sunset: ${DateFormat('hh:mm a').format(sunset)}'),
        if (main['temp'] < 7) Text('Recommended: Use winter tires'),
        if (weather['uvi'] != null && weather['uvi'] > 7) Text('Warning: High UV index'),
      ],
    );
  }
}
