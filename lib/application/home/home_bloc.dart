import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sdk_weather/application/home/home_event.dart';
import 'package:sdk_weather/application/home/home_state.dart';
import 'package:sdk_weather/application/model/weather_data.dart';
import 'package:sdk_weather/data/home/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  HomeBloc({required this.homeRepository}) : super(HomeState()) {
    on<Init>((event, emit) async{
      await getLastFetchWeather(event, emit);
    });
    on<SearchLocation>((event, emit) {
      emit(state.copyWith(location: event.location, errorMessage: ''));
    });
    on<FetchWeather>((event, emit) async {
      await getWeather(event, emit);
    });
    add(Init());
  }

  Future<void> getLastFetchWeather(Init event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cached_weather');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      emit(state.copyWith(weatherData: WeatherData.fromJson(jsonMap), isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future getWeather(FetchWeather event, Emitter<HomeState> emit) async {
    try {
      if (!isValid) {
        emit(state.copyWith(errorMessage: "Please enter the city"));
        return;
      }
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == [ConnectivityResult.none]) {
        emit(state.copyWith(
          errorMessage: "No Internet Connection",
          isLoading: false,
        ));
        return;
      }
      emit(state.copyWith(isLoading: true));
      final data = await homeRepository.getWeather(state.location!);
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(data.toJson());
      await prefs.setString('cached_weather', jsonString);
      emit(state.copyWith(weatherData: data, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  bool get isValid => state.location != null && state.location != '';
}
