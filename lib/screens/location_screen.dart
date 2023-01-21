import 'package:clima_app/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/utilities/constants.dart';
import 'package:clima_app/services/weather.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationData});

  final dynamic locationData;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late int wTemperature;
  late String wIcon;
  late String wStatus;
  late String wCity;

  void updateUI(dynamic locationData) {
    setState(() {
      if (locationData == null) {
        wIcon = 'Error';
        wCity = '';
        wStatus = 'Unable to get weather data';
        wTemperature = 0;

        return;
      }

      wCity = locationData['name'];

      int condition = locationData['weather'][0]['id'];
      wIcon = weatherModel.getWeatherIcon(condition);

      double temp = locationData['main']['temp'];
      wTemperature = temp.toInt();

      wStatus = weatherModel.getMessage(wTemperature);
    });
  }

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      dynamic weatherData =
                          await weatherModel.getLocationWeather();

                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CityScreen(),
                        ),
                      );

                      if (typedName != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(typedName);

                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Text(
                      '$wTemperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      wIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  '$wStatus in $wCity!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
