import 'package:sdk_weather/application/model/weather_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> _cacheWeatherData(WeatherData data) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(data.toJson());
  await prefs.setString('cached_weather', jsonString);
}
