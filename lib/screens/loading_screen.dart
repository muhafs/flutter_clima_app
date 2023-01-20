// ignore_for_file: avoid_print

import 'package:clima_app/screens/location_screen.dart';
import 'package:clima_app/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/services/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const String apiKey = '9185d45341d672570c0d36306db1f58d';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double longitude;
  late double latitude;

  void getLocationData() async {
    // Get Current Location
    Location location = Location();
    await location.getCurrentLocation();

    // Set Lat&Lon
    latitude = location.latitude;
    longitude = location.longitude;

    // Get Current Weather
    NetworkHelper networkHelper = NetworkHelper(
      url:
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey',
    );
    var weatherData = await networkHelper.getData();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const LocationScreen()),
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
