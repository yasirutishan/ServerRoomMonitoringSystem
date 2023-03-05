import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(MyApp());
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
  List<SalesDetails> sales = [];

  Future<String> getJsonFromFirebase() async {
    String url =
        "https://sever-monitoring-system-default-rtdb.asia-southeast1.firebasedatabase.app/data.json";
    http.Response response = await http.get(Uri.parse(url));
    return response.body.toString();
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFromFirebase();
    // print(jsonString);
    final dynamic jsonRespnse = jsonDecode(jsonString);
    for (Map<String, dynamic> i in jsonRespnse) {
      sales.add(SalesDetails.fromJson(i));
    }
  }

  @override
  void initState() {
    loadSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('chart test'),
        ),
        body: FutureBuilder(
          future: getJsonFromFirebase(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  SplineSeries<SalesDetails, String>(
                    dataSource: sales,
                    xValueMapper: (SalesDetails details, _) => details.month,
                    yValueMapper: (SalesDetails details, _) =>
                        details.salesCount,
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class SalesDetails {
  SalesDetails(this.month, this.salesCount);
  final String month;
  final double salesCount;

  factory SalesDetails.fromJson(Map<String, dynamic> parsedJson) {
    // print(parsedJson);
    var salesCountVal = parsedJson['salesCount'] * 1.0;
    return SalesDetails(parsedJson['month'] as String, salesCountVal);
  }
}
