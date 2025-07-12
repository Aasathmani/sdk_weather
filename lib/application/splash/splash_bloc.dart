import 'package:bloc/bloc.dart';
import 'package:sdk_weather/application/splash/splash_event.dart';
import 'package:sdk_weather/application/splash/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<Init>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(navigation: Navigation.home));
    });
    add(Init());
  }
}

enum Navigation { none, home }
