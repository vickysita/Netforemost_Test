class Weather {
  final String city;
  final String description;
  final double temperature;
  final String weatherDescription;
  final DateTime currentTime;

  Weather({
    required this.city,
    required this.description,
    required this.temperature,
    required this.weatherDescription,
    required this.currentTime,
  });

  factory Weather.fromWeatherData(
      String city, String description, Map<String, dynamic> weatherData) {
    final temp = weatherData['main']['temp'] ?? 0.0;
    final weatherDesc = weatherData['weather'][0]['description'] ?? 'N/A';
    final currentTime =
        DateTime.fromMillisecondsSinceEpoch(weatherData['dt'] * 1000);

    return Weather(
      city: city,
      description: description,
      temperature: temp - 273.15, // Convertir a Celsius
      weatherDescription: weatherDesc,
      currentTime: currentTime.toLocal(),
    );
  }
}
