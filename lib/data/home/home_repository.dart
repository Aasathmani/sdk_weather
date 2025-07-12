import 'package:sdk_weather/application/model/weather_data.dart';
import 'package:sdk_weather/data/home/home_service.dart';

class HomeRepository {
  static HomeRepository? instance;
  final HomeService homeService;
  HomeRepository({required this.homeService});

  Future<WeatherData> getWeather(String location)async{
    final dataFromResponse=await homeService.fetchWeather(location);
    final data=_toWeatherData(dataFromResponse.data);
    return data;
  }

  WeatherData _toWeatherData(Map<String,dynamic>json){
    return WeatherData.fromJson(json);
  }
}
