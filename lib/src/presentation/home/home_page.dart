import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdk_weather/src/application/home/home_bloc.dart';
import 'package:sdk_weather/src/application/home/home_state.dart';
import 'package:sdk_weather/src/application/model/weather_data.dart';
import 'package:sdk_weather/src/core/app_constants.dart';
import 'package:sdk_weather/src/presentation/widgtes/bordered_text_field.dart';
import 'package:sdk_weather/src/presentation/widgtes/snack_bar.dart';

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
              padding: const EdgeInsets.symmetric(
                vertical: Units.kXXXLPadding,
                horizontal: Units.kStandardPadding,
              ),
              child: Column(
                children: [
                  Image.asset(
                    AppIcons.kAppIcon,
                    height: Units.kShadowBoxHeight,
                  ),
                  _getLocationSearchLayout(context),
                  if (state.location == null &&
                      state.location != '' &&
                      state.weatherData == null)
                    Padding(
                      padding: EdgeInsets.only(top: Units.kXXXLPadding),
                      child: Text(
                        "No data available",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  if (state.isLoading) CircularProgressIndicator(),
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
      padding: const EdgeInsets.only(top: Units.kXXLPadding),
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
      padding: const EdgeInsets.only(top: Units.kXXLPadding),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(Units.kLPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getHeaderLayout(context, data),
              const SizedBox(height: 20),

              WeatherInfoTile(
                icon: Icons.thermostat_outlined,
                color: Colors.orange,
                text: 'Temperature: ${data.main.temp}°C',
              ),
              WeatherInfoTile(
                icon: Icons.device_thermostat,
                color: Colors.deepOrange,
                text: 'Feels like: ${data.main.feelsLike}°C',
              ),
              WeatherInfoTile(
                icon: Icons.opacity,
                color: Colors.blue,
                text: 'Humidity: ${data.main.humidity}%',
              ),
              WeatherInfoTile(
                icon: Icons.speed,
                color: Colors.green,
                text: 'Pressure: ${data.main.pressure} hPa',
              ),
              WeatherInfoTile(
                icon: Icons.wind_power,
                color: Colors.teal,
                text: 'Wind: ${data.wind.speed} m/s, ${data.wind.deg}°',
              ),
              WeatherInfoTile(
                icon: Icons.cloud,
                color: Colors.grey,
                text: 'Clouds: ${data.clouds.all}%',
              ),
              WeatherInfoTile(
                icon: Icons.visibility,
                color: Colors.indigo,
                text:
                    'Visibility: ${(data.visibility / 1000).toStringAsFixed(1)} km',
              ),
              WeatherInfoTile(
                icon: Icons.wb_sunny,
                color: Colors.yellow.shade700,
                text: 'Sunrise: ${_formatTime(data.sys.sunrise)}',
              ),
              WeatherInfoTile(
                icon: Icons.nights_stay,
                color: Colors.deepPurple,
                text: 'Sunset: ${_formatTime(data.sys.sunset)}',
              ),

              const SizedBox(height: 10),
              Divider(),
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

          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     _getHeaderLayout(context, data),
          //     SizedBox(height: 20),
          //     _getTemperatureLayout(data),
          //     SizedBox(height: 10),
          //     _getFeelsLikeLayout(data),
          //     SizedBox(height: 10),
          //     _getHumidityLayout(data),
          //     SizedBox(height: 10),
          //     _getPressureLayout(data),
          //     SizedBox(height: 10),
          //
          //     Row(
          //       children: [
          //         Icon(Icons.wind_power, color: Colors.teal),
          //         SizedBox(width: 8),
          //         Text(
          //           'Wind: ${data.wind.speed} m/s, ${data.wind.deg}°',
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 10),
          //
          //     Row(
          //       children: [
          //         Icon(Icons.cloud, color: Colors.grey),
          //         SizedBox(width: 8),
          //         Text(
          //           'Clouds: ${data.clouds.all}%',
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 10),
          //     _getVisibilityLayout(data),
          //     SizedBox(height: 20),
          //     _getSunriseLayout(data),
          //     SizedBox(height: 10),
          //     _getSunSetLayout(data),
          //     SizedBox(height: 20),
          //     Divider(),
          //     _getDescriptionLayout(context, data),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _getHeaderLayout(BuildContext context, WeatherData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: Colors.red,
              size: Units.kAppIconSize,
            ),
            SizedBox(width: 8),
            Text(
              '${data.name}, ${data.sys.country}',
              style: TextStyle(
                fontSize: Units.kAppIconSizeSmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Image.network(
          'https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png',
          height: Units.kShadowBoxHeight,
        ),
      ],
    );
  }

  Widget _getTemperatureLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.thermostat_outlined, color: Colors.orange),
        SizedBox(width: 8),
        Text(
          'Temperature: ${data.main.temp}°C',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getFeelsLikeLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.device_thermostat, color: Colors.deepOrange),
        SizedBox(width: 8),
        Text(
          'Feels like: ${data.main.feelsLike}°C',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getHumidityLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.opacity, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          'Humidity: ${data.main.humidity}%',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getPressureLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.speed, color: Colors.green),
        SizedBox(width: 8),
        Text(
          'Pressure: ${data.main.pressure} hPa',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getVisibilityLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.visibility, color: Colors.indigo),
        SizedBox(width: 8),
        Text(
          'Visibility: ${data.visibility / 1000} km',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getSunriseLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.wb_sunny, color: Colors.yellow.shade700),
        SizedBox(width: 8),
        Text(
          'Sunrise: ${_formatTime(data.sys.sunrise)}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getSunSetLayout(WeatherData data) {
    return Row(
      children: [
        Icon(Icons.nights_stay, color: Colors.deepPurple),
        SizedBox(width: 8),
        Text(
          'Sunset: ${_formatTime(data.sys.sunset)}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _getDescriptionLayout(BuildContext context, WeatherData data) {
    return Center(
      child: Text(
        data.weather[0].description.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return TimeOfDay.fromDateTime(date).format(context);
  }
}

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const WeatherInfoTile({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
