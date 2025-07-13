import 'package:sdk_weather/src/application/model/weather_data.dart';

class HomeState {
  String? location;
  String? errorMessage;
  WeatherData? weatherData;
  bool isLoading;
  HomeState({
    this.location,
    this.errorMessage,
    this.weatherData,
    this.isLoading = false,
  });
  HomeState copyWith({
    String? location,
    String? errorMessage,
    WeatherData? weatherData,
    bool? isLoading,
  }) {
    return HomeState(
      location: location ?? this.location,
      errorMessage: errorMessage ?? this.errorMessage,
      weatherData: weatherData ?? this.weatherData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
