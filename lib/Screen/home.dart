import 'package:flutter/material.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_services.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //* api key

  final _weatherService = WeatherServices("19413fc8be5c2a22742b4974b56fcb8b");
  Weather? _weather;

  //* fetch weather
  _fetchweather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      //* get city weather
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //* any errors
    catch (e) {
      print(e);
    }
  }
  //* weather animations

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'lib/assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return "lib/assets/windy.json";

      case 'rain':
        return "lib/assets/light_rain.json";

      case "thunderstorm":
        return "lib/assets/storm.json";

      case "clear":
        return "lib/assets/sunny.json";

      case "shower rain":
        return "lib/assets/light_rain.json";

      default:
        return "lib/assets/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchweather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Current Weather",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 42,
                  fontFamily: "Nexa",
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                width: 350,
                height: 430,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white.withValues(alpha: 0.1),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _weather?.cityName ?? "Loading...",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Nexa",
                        ),
                      ),
                      Lottie.asset(
                        getWeatherAnimation(_weather?.weatherCondition),
                        height: 120,
                      ),
                      Text(
                        '${_weather?.temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nexa",
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Wind: ${_weather?.wind.toStringAsFixed(1)} m/s',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18,
                          fontFamily: "Nexa",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
