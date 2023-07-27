import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:wheatherapp/reuseablewidget.dart';
import 'package:wheatherapp/secrets.dart';
import 'package:wheatherapp/wheather_model.dart';
import 'package:http/http.dart' as http;

class WheatherApp extends StatefulWidget {
  const WheatherApp({super.key});

  @override
  State<WheatherApp> createState() => _WheatherAppState();
}

class _WheatherAppState extends State<WheatherApp> {
  List<WheatherApi> wheatherlist = [];
  Future<List<WheatherApi>> getWheatherApi() async {
    //https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=2b3d4bc245693fcd2a5d219756a297a7'
    String cityName = 'London';
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$openWheatherApiKey'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        wheatherlist.add(WheatherApi.fromJson(i.cast()));
      }
    } else {
      return wheatherlist;
    }
    return wheatherlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wheather Api'),
        ),
        body: FutureBuilder(
          future: getWheatherApi(),
          builder: (context, AsyncSnapshot<List<WheatherApi>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: wheatherlist.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ReuseableRow(
                          title: 'Temprature ',
                          value: snapshot.data![index].main!.temp.toString()),
                      ReuseableRow(
                          title: 'Temprature Max',
                          value:
                              snapshot.data![index].main!.tempMax.toString()),
                      ReuseableRow(
                          title: 'Temprature Min',
                          value:
                              snapshot.data![index].main!.tempMin.toString()),
                      ReuseableRow(
                          title: 'FeelsLike',
                          value:
                              snapshot.data![index].main!.feelsLike.toString()),
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}
