import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphTemp extends StatelessWidget {
  const GraphTemp({super.key, required this.refString});
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
                double.parse(values["temperature"].toString()),
                double.parse(values["humidity"].toString()),
                double.parse(values["voltage"].toString()),
                double.parse(values["vibration"].toString()));
            data.add(p);
          });

          return Center(
            child: SfCartesianChart(
              primaryXAxis: DateTimeCategoryAxis(
                interval: 15, dateFormat: DateFormat('MM-dd hh:mm a'),
                // set the dateTimeAxisDateFormat property to format the date without seconds
              ),
              title: ChartTitle(text: 'Temperature data'),
              legend: Legend(isVisible: true),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              enableAxisAnimation: true,
              // Initialize category axis.
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
  }
}

class GraphHumid extends StatelessWidget {
  const GraphHumid({super.key, required this.refString});
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
                double.parse(values["temperature"].toString()),
                double.parse(values["humidity"].toString()),
                double.parse(values["voltage"].toString()),
                double.parse(values["vibration"].toString()));
            data.add(p);
          });

          return Center(
            child: SfCartesianChart(
              primaryXAxis: DateTimeCategoryAxis(
                interval: 1, dateFormat: DateFormat('MM-dd hh:mm a'),
                // set the dateTimeAxisDateFormat property to format the date without seconds
              ),
              title: ChartTitle(text: 'Humidity data'),
              legend: Legend(isVisible: true),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              enableAxisAnimation: false, // Initialize category axis.
              series: <LineSeries<DataPoint, DateTime>>[
                // Initialize line series.
                LineSeries<DataPoint, DateTime>(
                    name: "Humidity",
                    dataSource: data,
                    xValueMapper: (DataPoint dp, _) => dp.dateTime,
                    yValueMapper: (DataPoint dp, _) => dp.humidity)
              ],
            ),
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class GraphVoltage extends StatelessWidget {
  const GraphVoltage({super.key, required this.refString});
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
                double.parse(values["temperature"].toString()),
                double.parse(values["humidity"].toString()),
                double.parse(values["voltage"].toString()),
                double.parse(values["vibration"].toString()));
            data.add(p);
          });

          return Center(
            child: SfCartesianChart(
              primaryXAxis: DateTimeCategoryAxis(
                interval: 1, dateFormat: DateFormat('MM-dd hh:mm a'),
                // set the dateTimeAxisDateFormat property to format the date without seconds
              ),
              title: ChartTitle(text: 'Voltage data'),
              legend: Legend(isVisible: true),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              enableAxisAnimation: false, // Initialize category axis.
              series: <LineSeries<DataPoint, DateTime>>[
                // Initialize line series.
                LineSeries<DataPoint, DateTime>(
                    name: "Voltage",
                    dataSource: data,
                    xValueMapper: (DataPoint dp, _) => dp.dateTime,
                    yValueMapper: (DataPoint dp, _) => dp.voltage)
              ],
            ),
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class GraphVibration extends StatelessWidget {
  const GraphVibration({super.key, required this.refString});
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
                double.parse(values["temperature"].toString()),
                double.parse(values["humidity"].toString()),
                double.parse(values["voltage"].toString()),
                double.parse(values["vibration"].toString()));
            data.add(p);
          });

          return Center(
            child: SfCartesianChart(
              primaryXAxis: DateTimeCategoryAxis(
                interval: 1, dateFormat: DateFormat('MM-dd hh:mm a'),
                // set the dateTimeAxisDateFormat property to format the date without seconds
              ),
              title: ChartTitle(text: 'Vibration data'),
              legend: Legend(isVisible: true),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              enableAxisAnimation: false,
              // Initialize category axis.
              series: <LineSeries<DataPoint, DateTime>>[
                // Initialize line series.
                LineSeries<DataPoint, DateTime>(
                    name: "Vibration",
                    dataSource: data,
                    xValueMapper: (DataPoint dp, _) => dp.dateTime,
                    yValueMapper: (DataPoint dp, _) => dp.vibration)
              ],
            ),
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class GraphBuilder extends StatefulWidget {
  const GraphBuilder({super.key, required this.refString, required this.vital});
  final String refString;
  final String vital;

  @override
  State<GraphBuilder> createState() => _GraphBuilderState();
}

class _GraphBuilderState extends State<GraphBuilder> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableMouseWheelZooming: true,
        enableSelectionZooming: true,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 2,
        selectionRectColor: Colors.green);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(widget.refString);
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
              double.parse(values["temperature"].toString()),
              double.parse(values["humidity"].toString()),
              double.parse(values["voltage"].toString()),
              double.parse(values["vibration"].toString()),
            );
            data.add(p);
          });

          return Center(
            child: SfCartesianChart(
              primaryXAxis: DateTimeCategoryAxis(
                  interval: 1,
                  dateFormat: DateFormat('MM-dd hh:mm a'),
                  minimum: DateTime.now().subtract(
                    const Duration(minutes: 1),
                  ),
                  interactiveTooltip: const InteractiveTooltip(enable: false)
                  // set the dateTimeAxisDateFormat property to format the date without seconds
                  ),
              primaryYAxis: NumericAxis(
                  interactiveTooltip: const InteractiveTooltip(enable: false)),
              title: ChartTitle(text: 'Vibration data'),
              legend: Legend(isVisible: true),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: _zoomPanBehavior,
              enableAxisAnimation: false,
              // Initialize category axis.
              series: <LineSeries<DataPoint, DateTime>>[
                // Initialize line series.
                LineSeries<DataPoint, DateTime>(
                    name: "Vibration",
                    dataSource: data,
                    xValueMapper: (DataPoint dp, _) => dp.dateTime,
                    yValueMapper: (DataPoint dp, _) => dp.vibration)
              ],
            ),
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
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
