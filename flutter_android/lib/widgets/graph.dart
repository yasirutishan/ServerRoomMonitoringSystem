import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DrawGraph extends StatelessWidget {
  const DrawGraph({super.key, required this.refString});
  final String refString;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Half yearly sales analysis'),
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior:
                TooltipBehavior(enable: true), // Initialize category axis.
            series: <SplineAreaSeries<SalesData, String>>[
          // Initialize line series.
          SplineAreaSeries<SalesData, String>(
              dataSource: [
                SalesData('Jan', 35),
                SalesData('Feb', 28),
                SalesData('Mar', 34),
                SalesData('Apr', 32),
                SalesData('May', 40)
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales)
        ]));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
