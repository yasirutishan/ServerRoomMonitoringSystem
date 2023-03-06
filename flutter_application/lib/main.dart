import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChartPage(),
    );
  }
}

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<SensorData> sensorData = [];
  DatabaseReference ref = FirebaseDatabase.instance.ref("sensor_1_data");

  void loadSensorData() async {
    // Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> map = event.snapshot.value as Map;

      for (var key in map.values) {
        setState(() {
          sensorData.add(SensorData.fromJson(key));
        });
      }
    });
  }

  @override
  void initState() {
    loadSensorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('chart test'),
          ),
          body: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <ChartSeries<SensorData, DateTime>>[
                // Renders line chart
                LineSeries<SensorData, DateTime>(
                    dataSource: sensorData,
                    xValueMapper: (SensorData data, _) => data.time,
                    yValueMapper: (SensorData data, _) => data.temperature)
              ])

          // SfCartesianChart(
          //   primaryXAxis: DateTimeAxis(),
          //   series: <ChartSeries>[
          //     SplineSeries<SensorData, DateTime>(
          //         dataSource: sensorData,
          //         xValueMapper: (SensorData data, _) => data.timeStamp,
          //         yValueMapper: (SensorData data, _) => data.temperature)
          //   ],
          // ),
          ),
    );
  }
}

class SensorData {
  SensorData(
      this.time, this.fire, this.humidity, this.temperature, this.voltage);
  final DateTime time;
  final bool fire;
  final double temperature;
  final double humidity;
  final double voltage;

  factory SensorData.fromJson(Map<dynamic, dynamic> parsedJson) {
    double st = int.parse(parsedJson["timeStamp"]) / 1000;
    var date = DateTime.fromMicrosecondsSinceEpoch(st.round());
    print(date);

    return SensorData(
        date,
        parsedJson["fire"],
        double.parse(
            parsedJson["humid"].toString().replaceAll(RegExp(r'[^0-9.]'), '')),
        double.parse(
            parsedJson["temp"].toString().replaceAll(RegExp(r'[^0-9.]'), '')),
        double.parse(parsedJson["voltage"]
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '')));
  }
}
