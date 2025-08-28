import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather.dart';

class WeatherServices {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );
    print('Weather API response: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        "Failed to load weather data: ${error['message'] ?? response.reasonPhrase}",
      );
    }
  }

  //* Permission

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? locality = placemark[0].locality;
    String? subArea = placemark[0].subAdministrativeArea;
    String? country = placemark[0].country;

    print('Trying locality: $locality');

    try {
      await getWeather(locality ?? "");
      return locality ?? "";
    } catch (e) {
      if (e.toString().contains("city not found")) {
        print('Fallback to subAdministrativeArea: $subArea');
        try {
          await getWeather(subArea ?? "");
          return subArea ?? "";
        } catch (e) {
          print('Fallback to country: $country');
          return country ?? "";
        }
      } else {
        rethrow;
      }
    }
  }
}
