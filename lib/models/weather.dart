class Weather {
  final String cityName;
  final double temperature;
  final String weatherCondition;
  final double wind;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherCondition,
    required this.wind,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'],
      weatherCondition: json['weather'][0]['main'],
      wind: json['wind']['speed'],
    );
  }
}
