import 'package:flutter/material.dart';
import 'package:aer/services/weather_service.dart';
import 'package:flutter/services.dart';
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
  String searchText = '';

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
        print('Weather data: ${_weatherData.toString()}');
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _updateCity(String newCity) {
    setState(() {
      _city = newCity;
      searchText = newCity;
      _fetchWeather();
      print('City updated to $_city');
    });
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
          icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30),
          onPressed: () {SystemNavigator.pop();},
        ),
        title: Image.asset('lib/images/aer_logo.png', height: 40),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
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

      extendBodyBehindAppBar: true,
      bottomNavigationBar: Footer(context, _city, _updateCity),
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
              Text(
                _city,
                style: GoogleFonts.comfortaa(
                  fontSize: 70, // Adjust size as needed
                  color: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.05),
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
                          fontSize: 200,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '°',
                        style: GoogleFonts.comfortaa(
                          fontSize: 100,
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
      final formattedDate = DateFormat('EEEE').format(date);

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
Widget Footer(BuildContext context, String city, Function(String) updateCity) {
  return Container(
    color: const Color.fromARGB(255, 19, 113, 255),
    padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for a location',
                      hintStyle: GoogleFonts.comfortaa(color: Colors.white),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.comfortaa(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white,),
                  onPressed: () {
                    updateCity(searchText);
                  },
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeatherForecastPage(city: _city),
              ),
            );
          },
          child: Text(
            'Get Weather Forecast for $_city',
            style: GoogleFonts.comfortaa(
              fontSize: 17,
              color: Color.fromARGB(255, 19, 113, 255),
              fontWeight: FontWeight.w700,
            ),
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