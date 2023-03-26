import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeDisplay extends StatelessWidget {
  const GaugeDisplay({super.key, required this.refString, required this.vital});
  final String refString;
  final String vital;

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
            val = values[vital];
          });

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(vital),
                SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 70, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0, endValue: 20, color: Colors.green),
                    GaugeRange(
                        startValue: 20, endValue: 35, color: Colors.orange),
                    GaugeRange(startValue: 35, endValue: 70, color: Colors.red)
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
