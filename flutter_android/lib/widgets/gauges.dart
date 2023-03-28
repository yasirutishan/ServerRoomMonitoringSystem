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
        if (snapshot.hasData) {
          // print("Error on the way");
          DataSnapshot dataValues = snapshot.data!
              .snapshot; //Error: The getter snapshot is not defined for the type 'Object';
          Map<dynamic, dynamic> values = dataValues.value as Map;
          values.forEach((key, values) {
            // t.add(values);
            print(values);
            val = values["temperature"];
          });

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Temperature"),
                SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 70, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0, endValue: 18, color: Colors.lightBlue),
                    GaugeRange(
                        startValue: 18,
                        endValue: 24,
                        color: Colors.greenAccent),
                    GaugeRange(
                        startValue: 24, endValue: 30, color: Colors.orange),
                    GaugeRange(startValue: 30, endValue: 70, color: Colors.red)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(
                      value: val.toDouble(),
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                    )
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(val.toString(),
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ]),
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
            print(values);
            val = values["humidity"];
          });

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Humidity"),
                SfRadialGauge(axes: <RadialAxis>[
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
                        widget: Text(val.toString(),
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ]),
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
