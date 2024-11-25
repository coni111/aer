import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherForecastPage extends StatelessWidget {
  final String city;

  WeatherForecastPage({required this.city});

  Future<Map<String, dynamic>> fetchWeather() async {
    final String? apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key is not loaded properly');
    }

    final fallbackCity = 'Budapest';
    final url = 'https://api.openweathermap.org/data/2.5/forecast?q=${city.isEmpty ? fallbackCity : city}&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data: ${response.body}');
    }
  }

  String _getBackgroundImage(String weatherType) {
    switch (weatherType) {
      case 'Clear':
        return 'lib/images/windturbine_bg.png';
      case 'Clouds':
        return 'lib/images/clouds_bg.png';
      case 'Rain':
        return 'lib/images/rain_bg.png';
      case 'Snow':
        return 'lib/images/snow_bg.png';
      case 'Thunderstorm':
        return 'lib/images/thunderstorm_bg.png';
      case 'Drizzle':
        return 'lib/images/windturbine_bg.png';
      case 'Mist':
        return 'lib/images/mwindturbine_bg.png';
      default:
        return 'lib/images/windturbine_bg.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Ensure the background extends behind the app bar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context); // This will pop the current route
          },
        ),
        title: Image.asset('lib/images/aer_logo.png', height: 40), // Logo image
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open the drawer
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage('lib/images/clouds_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('lib/images/aer_logo.png', height: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Quit',
                      style: GoogleFonts.comfortaa(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'GitHub',
                      style: GoogleFonts.comfortaa(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.code, color: Colors.white),
                      onPressed: () async {
                        const url = 'https://github.com/coni111';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Aer is a weather app with modern design, made as a school project 🌦',
                      style: GoogleFonts.comfortaa(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),



      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final weatherData = snapshot.data!;
            final backgroundImage = _getBackgroundImage(weatherData['list'][0]['weather'][0]['main']);
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: _weeklyForecast(weatherData),
            );
          }
        },
      ),
    );
  }

  Widget _weeklyForecast(Map<String, dynamic> weatherData) {
    if (!weatherData.containsKey('list')) {
      return Center(child: Text('No forecast data available'));
    }

    final dailyForecast = weatherData['list'];

    return ListView.builder(
      itemCount: dailyForecast.length,
      itemBuilder: (context, index) {
        final day = dailyForecast[index];
        final date = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
        final formattedDate = DateFormat('EEEE').format(date);
        final tempMin = day['main']['temp_min'].toInt();
        final tempMax = day['main']['temp_max'].toInt();
        final weatherType = day['weather'][0]['main'];
        final weatherDescription = day['weather'][0]['description'];

        final weatherImages = {
          'Clear': 'lib/images/sun.png',
          'Clouds': 'lib/images/clouds.png',
          'Rain': 'lib/images/rain.png',
          'Snow': 'lib/images/snow.png',
          'Thunderstorm': 'lib/images/storm.png',
          'Drizzle': 'lib/images/mist.png',
          'Mist': 'lib/images/mist.png'
        };

        return ListTile(
          leading: Image.asset(
            weatherImages[weatherType] ?? 'lib/images/sun.png',
            width: 50,
            height: 50,
          ),
          title: Text(formattedDate, style: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),),
          subtitle: Text('H: $tempMax°C L: $tempMin°C\nWeather: $weatherDescription', style: GoogleFonts.comfortaa(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w300),),
        );
      },
    );
  }
}
