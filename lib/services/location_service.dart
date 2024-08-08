import 'package:dio/dio.dart';
import 'package:interview_flutter/pages/weathers/model/weather.dart';

class LocationService {
  final Dio _dio; //Dio para realizar la solicitud HTTP

  LocationService()
      : _dio = Dio(BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 3000,
        ));

  //Obtener información del clima dependiendo de la ciudad proporcionada
  Future<Weather> getWeather(String city) async {
    const apiKey = '74db58e3c5af0edf5421f281a75fbfaf'; //Cambia a tu API KEY

    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final weatherData = response.data;
        return Weather.fromWeatherData(
          city,
          '',
          weatherData,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } on DioError catch (e) {
      print(
          'Dio error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      throw Exception('Failed to load data');
    }
  }
}
