

import 'package:dio/dio.dart';

class HomeService {
  final Dio _dio = Dio();

  static const String _apiKey = '6a793ab53587a38141f135a88515df18';

  Future<Response> fetchWeather(String city) async {
    try {
      const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'q': city,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to fetch weather: ${e.response?.statusMessage.toString()}');
    }
  }
}
