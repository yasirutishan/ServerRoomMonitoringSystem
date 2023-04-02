import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureGuage extends StatelessWidget {
  const TemperatureGuage({super.key, required this.refString});
  final String refString;
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(refString);
    var val = 0;
    return StreamBuilder(
      stream: ref.limitToLast(1).orderByKey().onValue,
      builder: (context, snapshot) {
        // print("New value");

        if (snapshot.hasData) {
          // print("Error on the way");
          DataSnapshot dataValues = snapshot.data!
              .snapshot; //Error: The getter snapshot is not defined for the type 'Object';
          Map<dynamic, dynamic> values = dataValues.value as Map;
          values.forEach((key, values) {
            // t.add(values);
            // print(values);
            val = values["temperature"];
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Temperature"),
              Expanded(
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0.0, maximum: 70.0, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0.0,
                        endValue: 18.0,
                        color: Colors.lightBlue),
                    GaugeRange(
                        startValue: 18.0,
                        endValue: 24.0,
                        color: Colors.greenAccent),
                    GaugeRange(
                        startValue: 24.0, endValue: 30.0, color: Colors.orange),
                    GaugeRange(
                        startValue: 30.0, endValue: 70.0, color: Colors.red)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(
                      value: val.toDouble(),
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                    )
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text("$val C°",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ]),
              ),
            ],
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class HumidityGauge extends StatelessWidget {
  const HumidityGauge({super.key, required this.refString});
  final String refString;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(refString);
    var val = 0;
    return StreamBuilder(
      stream: ref.limitToLast(1).orderByKey().onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print("Error on the way");
          DataSnapshot dataValues = snapshot.data!
              .snapshot; //Error: The getter snapshot is not defined for the type 'Object';
          Map<dynamic, dynamic> values = dataValues.value as Map;
          values.forEach((key, values) {
            // t.add(values);
            // print(values);
            val = values["humidity"];
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Humidity"),
              Expanded(
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0, endValue: 40, color: Colors.lightBlue),
                    GaugeRange(
                        startValue: 40,
                        endValue: 60,
                        color: Colors.greenAccent),
                    GaugeRange(startValue: 60, endValue: 100, color: Colors.red)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(
                      value: val.toDouble(),
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                    )
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text("$val%",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ]),
              ),
            ],
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class VoltageGauge extends StatelessWidget {
  const VoltageGauge({super.key, required this.refString});
  final String refString;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(refString);
    var val = 0;
    return StreamBuilder(
      stream: ref.limitToLast(1).orderByKey().onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print("Error on the way");
          DataSnapshot dataValues = snapshot.data!
              .snapshot; //Error: The getter snapshot is not defined for the type 'Object';
          Map<dynamic, dynamic> values = dataValues.value as Map;
          values.forEach((key, values) {
            // t.add(values);
            // print(values);
            val = values["voltage"];
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Voltage"),
              Expanded(
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 184, maximum: 280, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 184,
                        endValue: 216,
                        color: Colors.lightBlue),
                    GaugeRange(
                        startValue: 216,
                        endValue: 248,
                        color: Colors.greenAccent),
                    GaugeRange(
                        startValue: 248, endValue: 280, color: Colors.red)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(
                      value: val.toDouble(),
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                    )
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text("${val}V",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ]),
              ),
            ],
          );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
