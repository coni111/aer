import 'package:flutter/material.dart';
import 'package:aer/api_models/weather_model.dart';
import 'package:aer/components/forecasting.dart';
import 'package:aer/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _weatherService = WeatherService('a10ef3b7410f0043ec659f036724025f');


  Weather? _weather;

  _fetchWeather() async {

    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    catch (e) {
      print(e);
    }
  }

  String translatedWeatherStatus = '';
  String getWeatherAnimation(String? mainCondition) {
      DateTime currentTime = DateTime.now();
      int hour = currentTime.hour;

      if (mainCondition == null) return 'lib/animations/LoadingAnimation.json';

      switch (mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
          translatedWeatherStatus = "Felhős";
          return 'lib/animations/Cloudy.json';
        case 'fog':
          translatedWeatherStatus = "Köd";
          return 'lib/animations/Fog.json';
        case 'rain':
        case 'driyyle':
        case 'shower rain':
          translatedWeatherStatus = "Esős";
          return 'lib/animations/Rainy.json';
        case 'thunderstorm':
          translatedWeatherStatus = "Vihar";
          return 'lib/animations/ThunderStorm.json';
        case 'clear':
          translatedWeatherStatus = "Tiszta égbolt";
          if (hour >= 19) {return 'lib/animations/Moon.json';}
          else {return 'lib/animations/Sunny.json';}
        default:
          translatedWeatherStatus = "";
          return 'lib/animations/LoadingAnimation.json';
      }
    }
  
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(0, 255, 255, 255),
      ),
      home: Scaffold(
    endDrawer: Drawer(
        child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  alignment: Alignment.center,
                  height: 130,
                  child: Image.asset(
                    'lib/images/logo_sidebar.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    
            Row(
              children: [
    
                SizedBox(width: 10),
    
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 187, 0),
                  radius: 25.0,
                ),
    
                SizedBox(width: 10),
              ],
            ),
    
            SizedBox(height: 10),
    
            ListTile(
              leading: Icon(Icons.settings, size: 30, color: Color.fromARGB(255, 255, 187, 0),),
              title: Text('Beállítások', style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.contacts, size: 30, color: Color.fromARGB(255, 255, 187, 0),),
              title: Text('Elérhetőségek', style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info, size: 30, color: Color.fromARGB(255, 255, 187, 0),),
              title: Text('Információk', style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.web, size: 30, color: Color.fromARGB(255, 255, 187, 0)),
              title: Text('Weboldal', style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.facebook, size: 30, color: Color.fromARGB(255, 255, 187, 0),),
              title: Text('Facebook', style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {},
            ),
            Expanded(
              child: Divider(
                thickness:  0.5,
                color: Color.fromARGB(0, 255, 255, 255)
              ),
            ),
            Text('''
      Fishingline 2023-2024 Verzió: 1.2.8
      Fejlesztette: nikkeisadev.
            ''', style: TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
        ),
      ),
        body: Container(
                decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/images/windturbine_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
          child: Center(
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                
                Divider(
                    thickness: 2,
                    color: const Color.fromARGB(255, 255, 187, 0),
                    indent: 110,
                    endIndent: 110,
                ),
    
                const SizedBox(height: 3),
    
                Text("Dátum, és idő:",
                style: TextStyle(color: Colors.white, fontSize: 13),
                ),
    
                //Text(
                    //'${DateFormat('HH:mm').format(DateTime.now())}  '
                    //'${DateFormat('yyyy.MM.dd').format(DateTime.now())}',
                    //style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500), textAlign: TextAlign.center,
                //),
    
                const SizedBox(height: 10),
    
                Text("Jelenlegi tartózkodási helyed:",
                style: TextStyle(color: Colors.white, fontSize: 13),
                ),
    
                const SizedBox(height: 20),
                
                Text(
                    _weather?.cityName ?? "Adatok lekérése...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    background: Paint()
                      ..color = const Color.fromARGB(255, 255, 187, 0)
                      ..strokeWidth = 35
                      ..strokeJoin = StrokeJoin.round
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 25),
                Text("A Jelenlegi hőmérséklet:",
                style: TextStyle(color: Colors.white, fontSize: 15),
                ),
    
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${_weather?.temperature.round()}°C',
                        style: TextStyle(fontSize: 40)
                      ),
                      const WidgetSpan(
                        child: Icon(
                          Icons.dew_point, 
                          size: 40,
                          color: const Color.fromARGB(255, 255, 187, 0),
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
       
      ),
    );
  }
}
