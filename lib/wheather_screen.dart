import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheatherapp/aditionalinfo_item.dart';
import 'package:wheatherapp/card.dart';
import 'package:http/http.dart' as http;
import 'package:wheatherapp/secrets.dart';

class WheatherScreen extends StatefulWidget {
  const WheatherScreen({super.key});

  @override
  State<WheatherScreen> createState() => _WheatherScreenState();
}

class _WheatherScreenState extends State<WheatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWheather() async {
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWheatherApiKey'));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'Unexpected error occure';
      }
      // data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWheather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wheather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWheather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;
            final curentwhetherdata = data['list'][0];
            final currenttemp = curentwhetherdata['main']['temp'];
            final currentsky = curentwhetherdata['weather'][0]['main'];
            final currentpressure =
                curentwhetherdata['main']['pressure'].toString();
            final currentspeed = curentwhetherdata['wind']['speed'].toString();
            final currentHumidity =
                curentwhetherdata['main']['humidity'].toString();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currenttemp F',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32),
                                ),
                                currentsky == 'Clouds' || currentsky == 'Rain'
                                    ? const Icon(
                                        Icons.cloud,
                                        size: 67,
                                      )
                                    : const Icon(
                                        Icons.sunny,
                                        size: 67,
                                      ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  currentsky,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Wheather forecast card
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  /*  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i <= 38; i++)
                          CardWidget(
                            icon: data['list'][i + 1]['weather'][0]['main'] ==
                                        'Clouds' ||
                                    data['list'][i + 1]['weather'][0]['main'] ==
                                        'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temprature: data['list'][i + 1]['dt'].toString(),
                            time:
                                data['list'][i + 1]['main']['temp'].toString(),
                          ),
                      ],
                    ),
                  ), */

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final hourlyforecast = data['list'][index + 1];
                        final clouds = hourlyforecast['weather'][0]['main'];
                        final time = DateTime.parse(hourlyforecast['dt_txt']);
                        return CardWidget(
                            icon: clouds == 'Clouds' || clouds == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            time: DateFormat('j').format(time),
                            temprature:
                                hourlyforecast['main']['temp'].toString());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //Wheather forecast card
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity,
                      ),
                      AditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentspeed,
                      ),
                      AditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentpressure,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
