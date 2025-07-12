import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdk_weather/presentation/home/home_page.dart';

import '../../application/splash/splash_bloc.dart';
import '../../application/splash/splash_state.dart';

class SplashPage extends StatefulWidget {
  static const route = '/';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashBloc? _splashBloc;

  @override
  void didChangeDependencies() {
    _splashBloc ??= BlocProvider.of<SplashBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.navigation == Navigation.home) {
          Navigator.popAndPushNamed(context, HomePage.route);
        }
      },
      builder: (context, state) {
        return Scaffold(body: Center(child: Text("Welcome to Weather App..")),
        );
      },
    );
  }
}
