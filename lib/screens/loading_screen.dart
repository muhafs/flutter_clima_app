// ignore_for_file: avoid_print

import 'package:clima_app/screens/location_screen.dart';
import 'package:clima_app/services/weather.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getLocationData() async {
    dynamic weatherData = await WeatherModel().getLocationWeather();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => LocationScreen(locationData: weatherData)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
