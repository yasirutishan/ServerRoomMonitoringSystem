import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DrawGraph extends StatelessWidget {
  const DrawGraph({super.key, required this.refString});
  final String refString;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(refString);
    List<DataPoint> data = [];

    return StreamBuilder(
      stream: ref.limitToLast(1).orderByKey().onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print("Error on the way");
          DataSnapshot dataValues = snapshot.data!
              .snapshot; //Error: The getter snapshot is not defined for the type 'Object';
          Map<dynamic, dynamic> values = dataValues.value as Map;
          values.forEach((key, values) {
            // print(values);
            // val = values["temperature"];
            DataPoint p = DataPoint(
                DateTime.fromMicrosecondsSinceEpoch(
                    (values["timeStamp"] / 1000).toInt()),
                values["temperature"],
                values["humidity"],
                values["voltage"],
                values["vibration"]);
            data.add(p);
          });

          return Center(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Temperature data'),
              legend: Legend(isVisible: true),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              enableAxisAnimation: false, // Initialize category axis.
              series: <LineSeries<DataPoint, DateTime>>[
                // Initialize line series.
                LineSeries<DataPoint, DateTime>(
                    name: "Temperature",
                    dataSource: data,
                    xValueMapper: (DataPoint dp, _) => dp.dateTime,
                    yValueMapper: (DataPoint dp, _) => dp.temperature)
              ],
            ),
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );

    // return Center(
    //     child: SfCartesianChart(
    //         primaryXAxis: CategoryAxis(),
    //         title: ChartTitle(text: 'Half yearly sales analysis'),
    //         legend: Legend(isVisible: true),
    //         // Enable tooltip
    //         tooltipBehavior:
    //             TooltipBehavior(enable: true), // Initialize category axis.
    //         series: <SplineAreaSeries<SalesData, String>>[
    //       // Initialize line series.
    //       SplineAreaSeries<SalesData, String>(
    //           dataSource: [
    //             SalesData('Jan', 35),
    //             SalesData('Feb', 28),
    //             SalesData('Mar', 34),
    //             SalesData('Apr', 32),
    //             SalesData('May', 40)
    //           ],
    //           xValueMapper: (SalesData sales, _) => sales.year,
    //           yValueMapper: (SalesData sales, _) => sales.sales)
    //     ]));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class DataPoint {
  DataPoint(this.dateTime, this.temperature, this.humidity, this.voltage,
      this.vibration);
  final DateTime dateTime;
  final double temperature;
  final double humidity;
  final double voltage;
  final double vibration;
}
