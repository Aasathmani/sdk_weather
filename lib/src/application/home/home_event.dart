class HomeEvent {}

class Init extends HomeEvent{}

class SearchLocation extends HomeEvent {
  String? location;
  SearchLocation(this.location);
}

class FetchWeather extends HomeEvent{}
