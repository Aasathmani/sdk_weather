import 'package:sdk_weather/src/application/home/home_bloc.dart';
import 'package:sdk_weather/src/data/home/home_repository.dart';
import 'package:sdk_weather/src/data/home/home_service.dart';

HomeBloc provideHomeBloc() {
  return HomeBloc(homeRepository: provideHomeRepository());
}

HomeRepository provideHomeRepository() {
  return HomeRepository.instance ??= HomeRepository(homeService: HomeService());
}
