import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdk_weather/application/home/home_bloc.dart';
import 'package:sdk_weather/application/home/home_state.dart';
import 'package:sdk_weather/application/model/weather_data.dart';
import 'package:sdk_weather/presentation/widgtes/bordered_text_field.dart';
import 'package:sdk_weather/presentation/widgtes/snack_bar.dart';

import '../../application/home/home_event.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= BlocProvider.of<HomeBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage != '') {
          SnackBarHelper.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  Text("Weather app", style: TextStyle(fontSize: 30)),
                  _getLocationSearchLayout(context),
                  if (state.location == null &&
                      state.location != '' &&
                      state.weatherData == null)
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No data available",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  if (state.isLoading)
                    CircularProgressIndicator(),
                  if (state.weatherData != null && state.isLoading != true)
                    _buildWeatherInfo(state.weatherData!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getLocationSearchLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: BorderedTextField(
        hintText: "Search city",
        onTextChanged: (value) {
          _bloc!.add(SearchLocation(value));
        },
        prefixIcon: Icon(Icons.search_rounded),
        suffixIcon: InkWell(
          onTap: () {
            _bloc!.add(FetchWeather());
          },
          child: Icon(Icons.arrow_forward_outlined),
        ),
        borderColor: Colors.grey,
      ),
    );
  }

  Widget _buildWeatherInfo(WeatherData data) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${data.name}, ${data.sys.country}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png',
                    height: 60,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Temperature Row
              Row(
                children: [
                  Icon(Icons.thermostat_outlined, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Temperature: ${data.main.temp}°C',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.device_thermostat, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text(
                    'Feels like: ${data.main.feelsLike}°C',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.opacity, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Humidity: ${data.main.humidity}%',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.speed, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Pressure: ${data.main.pressure} hPa',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Wind and Cloud
              Row(
                children: [
                  Icon(Icons.wind_power, color: Colors.teal),
                  SizedBox(width: 8),
                  Text(
                    'Wind: ${data.wind.speed} m/s, ${data.wind.deg}°',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.cloud, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Clouds: ${data.clouds.all}%',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.visibility, color: Colors.indigo),
                  SizedBox(width: 8),
                  Text(
                    'Visibility: ${data.visibility / 1000} km',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Sunrise / Sunset
              Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.yellow.shade700),
                  SizedBox(width: 8),
                  Text(
                    'Sunrise: ${_formatTime(data.sys.sunrise)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.nights_stay, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    'Sunset: ${_formatTime(data.sys.sunset)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Divider(),

              // Description
              Center(
                child: Text(
                  data.weather[0].description.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
