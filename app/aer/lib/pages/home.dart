import 'package:flutter/material.dart';
import 'package:aer/services/weather_service.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aer/pages/forecast.dart';
import 'package:url_launcher/url_launcher.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = 'Nagyhegyes';
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
      // Print the full response to debug
      print('Weather data: ${_weatherData.toString()}');
    });
  } catch (e) {
    setState(() {
      _error = e.toString();
    });
  }
}



  String _getBackgroundImage(String weatherType) {
    switch (weatherType) {
      case 'clear':
        return 'lib/images/windturbine_bg.png';
      case 'clouds':
        return 'lib/images/clouds_bg.png';
      case 'rain':
        return 'lib/images/storm_bg.png';
      case 'snow':
        return 'lib/images/snow_bg.png';
      case 'thunderstorm':
        return 'lib/images/storm_bg.png';
      case 'drizzle':
        return 'lib/images/storm_bg.png';
      case 'mist':
        return 'lib/images/storm_bg.png';
      default:
        return 'lib/images/windturbine_bg.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherType = _weatherData != null ? _weatherData!['weather'][0]['main'].toLowerCase() : 'default';
    final backgroundImage = _getBackgroundImage(weatherType);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.white, size: 30),
          onPressed: () {
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
    color: const Color.fromARGB(255, 49, 80, 255), // Set the background color for the entire drawer
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 49, 80, 255), // Ensure the header has the same background color
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('lib/images/aer_logo.png', height: 30),
          ),
        ),
        ListTile(
          leading: Icon(Icons.code, color: Colors.white),
          title: Text('Github', style: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),),
          onTap: () async {
            const url = 'https://github.com/coni111';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Aer is a weather app with modern design, made as a school project 🌦', style: GoogleFonts.comfortaa(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),),
        ),
      ],
    ),
  ),
),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Footer(context, _city),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: _error != null
                  ? Center(
                      child: Text('Error: $_error', style: GoogleFonts.comfortaa(color: Colors.white)),
                    )
                  : _weatherData == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 200),
                              _currentWeather(),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentWeather() {
    final main = _weatherData!['main'];
    final weather = _weatherData!['weather'][0];
    final weatherDescription = weather['description'];
    final wind = _weatherData!['wind'];
    final sys = _weatherData!['sys'];
    final sunrise = DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000);

    final weatherType = weather['main'].toLowerCase();
    final weatherImages = {
      'clear': 'lib/images/sun.png',
      'clouds': 'lib/images/clouds.png',
      'rain': 'lib/images/rain.png',
      'snow': 'lib/images/snow.png',
      'thunderstorm': 'lib/images/storm.png',
      'drizzle': 'lib/images/mist.png',
      'mist': 'lib/images/mist.png'
    };

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              // City name with transparent white background
              Text(
                _city, // Assuming _city is defined and holds the city name
                style: GoogleFonts.comfortaa(
                  fontSize: 80, // Adjust size as needed
                  color: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.05), // Transparent white
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '${main['temp'].toInt()}',
                        style: GoogleFonts.comfortaa(
                          fontSize: 200, // Large font size for temperature
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '°',
                        style: GoogleFonts.comfortaa(
                          fontSize: 100, // Large font size for degree symbol
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'H: ${main['temp_max'].toInt()}°',
                style: GoogleFonts.comfortaa(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 20),
              Text(
                'L: ${main['temp_min'].toInt()}°',
                style: GoogleFonts.comfortaa(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Assuming weatherImages and weatherDescription are defined
              Image.asset(weatherImages[weatherType] ?? 'lib/images/sun.png', width: 30, height: 30),
              SizedBox(width: 8),
              Text(
                weatherDescription,
                style: GoogleFonts.comfortaa(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          if (main['temp'] < 7)
            Text(
              'Recommended: Use winter tires',
              style: GoogleFonts.comfortaa(
                color: Colors.orange,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          if (weather['uvi'] != null && weather['uvi'] > 7)
            Text(
              'Warning: High UV index',
              style: GoogleFonts.comfortaa(
                color: Colors.orange,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          SizedBox(height: 20),
          Text(
            'Sunrise: ${DateFormat('hh:mm a').format(sunrise)} Sunset: ${DateFormat('hh:mm a').format(sunset)}',
            style: GoogleFonts.comfortaa(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          Text(
            'Wind Speed: ${wind['speed']} m/s',
            style: GoogleFonts.comfortaa(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          Text(
            'Min Temp: ${main['temp_min']}°C Max Temp: ${main['temp_max']}°C',
            style: GoogleFonts.comfortaa(color: Colors.white),
          ),
          Text(
            'Humidity: ${main['humidity']}%',
            style: GoogleFonts.comfortaa(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyForecast() {
  if (_weatherData == null || !_weatherData!.containsKey('daily')) {
    return Center(
      child: Text('No forecast data available', style: GoogleFonts.comfortaa(color: Colors.white)),
    );
  }

  final dailyForecast = _weatherData!['daily'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: List.generate(dailyForecast.length, (index) {
      final day = dailyForecast[index];
      final date = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
      final formattedDate = DateFormat('EEEE').format(date); // Napi név

      final tempMin = day['temp']['min'].toInt();
      final tempMax = day['temp']['max'].toInt();
      final weatherType = day['weather'][0]['main'].toLowerCase();
      final weatherDescription = day['weather'][0]['description'];

      final weatherImages = {
        'clear': 'lib/images/sun.png',
        'clouds': 'lib/images/clouds.png',
        'rain': 'lib/images/rain.png',
        'snow': 'lib/images/snow.png',
        'thunderstorm': 'lib/images/storm.png',
        'drizzle': 'lib/images/mist.png',
        'mist': 'lib/images/mist.png'
      };

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate,
              style: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
            ),
            Row(
              children: [
                Image.asset(
                  weatherImages[weatherType] ?? 'lib/images/sun.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 8),
                Text(
                  weatherDescription,
                  style: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Text(
              'H: $tempMax°C L: $tempMin°C',
              style: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      );
    }),
  );
}
Widget Footer(BuildContext context, String _city) {
  return Container(
    color: const Color.fromARGB(255, 19, 113, 255), // Adjust opacity for transparency
    padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherForecastPage(city: _city),
                ),
              );
            },
            child: Text('Get Weather Forecast for $_city', style: GoogleFonts.comfortaa(fontSize: 20, color: Color.fromARGB(255, 19, 113, 255), fontWeight: FontWeight.w300),),
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Powered by OpenWeather',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    ),
  );
}
}