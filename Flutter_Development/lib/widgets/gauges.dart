import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureGuage extends StatelessWidget {
  const TemperatureGuage({super.key, required this.refString});
  final String refString;
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref(refString);
    double val = 0;
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
            val = double.parse(values["temperature"].toString());
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
                      value: val,
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
    double val = 0;
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
            val = double.parse(values["humidity"].toString());
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
                      value: val,
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
    double val = 0;
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
            val = double.parse(values["voltage"].toString());
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
                      value: val,
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                    )
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text("${val.toStringAsFixed(2)}V",
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

class BulbWidget extends StatefulWidget {
  const BulbWidget({Key? key}) : super(key: key);

  @override
  _BulbWidgetState createState() => _BulbWidgetState();
}

class _BulbWidgetState extends State<BulbWidget> {
  bool _isRed = false;
  bool _isFire = false;
  bool _isSmoke = false;

  @override
  void initState() {
    super.initState();
    final databaseReference = FirebaseDatabase.instance.ref().child('set');
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final alarm = data['alarm'] as bool?;
        final fire = data['fire'] as bool?;
        final smoke = data['smoke'] as bool?;
        if (alarm != null) {
          setState(() {
            _isRed = alarm;
          });
        }
        if (fire != null) {
          setState(() {
            _isFire = fire;
          });
        }
        if (smoke != null) {
          setState(() {
            _isSmoke = smoke;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alarmColor = _isRed ? Colors.red : Colors.green;
    final fireColor = _isFire ? Colors.red : Colors.green;
    final smokeColor = _isSmoke ? Colors.red : Colors.green;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Expanded(
              child: Icon(
                Icons.alarm,
                color: alarmColor,
                size: 75,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.fire_truck,
                color: fireColor,
                size: 75,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.propane_tank_sharp,
                color: smokeColor,
                size: 75,
              ),
            ),
          ],
        ),
        Text(
          _isRed || _isFire || _isSmoke ? "Check Alarms" : "All Systems Good",
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
