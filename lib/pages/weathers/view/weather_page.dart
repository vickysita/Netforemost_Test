import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interview_flutter/pages/weathers/model/weather.dart';
import 'package:interview_flutter/services/location_service.dart';
import 'package:interview_flutter/services/preferences_service.dart';
import 'package:interview_flutter/shared/providers.dart';
import 'package:intl/intl.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPage();
}

class _WeatherPage extends ConsumerState<WeatherPage> {
  late final PreferencesService _preferencesService;
  late final LocationService _locationService;
  List<Weather> _cityWeathers = [];

  @override
  void initState() {
    super.initState();
    _preferencesService = ref.read(preferencesServiceProvider);
    _locationService = ref.read(locationServiceProvider);
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    final savedLocations = await _preferencesService.getSavedLocations();
    final cityWeatherList = <Weather>[];

    for (var location in savedLocations) {
      final city = location['city']!;
      final description = location['description']!;
      final weather = await _fetchWeather(city);

      cityWeatherList.add(Weather(
        city: city,
        description: description,
        temperature: weather.temperature,
        weatherDescription: weather.weatherDescription,
        currentTime: weather.currentTime,
      ));
    }

    setState(() {
      _cityWeathers = cityWeatherList;
    });
  }

  Future<Weather> _fetchWeather(String city) async {
    try {
      final weather = await _locationService.getWeather(city);
      return weather;
    } catch (e) {
      print('Error fetching weather: $e');
      return Weather(
        city: city,
        description: 'N/A',
        temperature: 0.0,
        weatherDescription: 'N/A',
        currentTime: DateTime.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy hh:mm a');

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _cityWeathers.map((cityWeather) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(cityWeather.city),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${cityWeather.description}'),
                        Text(
                            'Temperature: ${cityWeather.temperature.toStringAsFixed(1)}°C'),
                        Text('Weather: ${cityWeather.weatherDescription}'),
                        Text(
                            'Current Time: ${dateFormat.format(cityWeather.currentTime)}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
