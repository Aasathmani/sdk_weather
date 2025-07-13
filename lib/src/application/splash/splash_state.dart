import 'package:sdk_weather/src/application/splash/splash_bloc.dart';

class SplashState {
  Navigation navigation;

  SplashState({this.navigation = Navigation.none});

  SplashState copyWith({Navigation? navigation}) {
    return SplashState(navigation: navigation ?? this.navigation);
  }
}
