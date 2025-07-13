import 'package:dio/dio.dart';
import 'package:sdk_weather/src/core/app_constants.dart';

class HomeService {
  final Dio _dio = Dio();

  static const String _apiKey = ApiKey.apiKey;

  Future<Response> fetchWeather(String city) async {
    try {
      const String baseUrl = ApiEndPoints.weatherApi;
      final response = await _dio.get(
        baseUrl,
        queryParameters: {'q': city, 'appid': _apiKey, 'units': 'metric'},
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch weather: ${e.response?.statusMessage.toString()}',
      );
    }
  }
}
