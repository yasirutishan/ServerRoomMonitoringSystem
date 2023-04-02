import 'package:flutter/material.dart';
import '../widgets/gauges.dart';
import '../widgets/graph.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: TemperatureGuage(refString: "sensor_1_data")),
                  Expanded(child: HumidityGauge(refString: "sensor_1_data")),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: VoltageGauge(refString: "sensor_1_data")),
                  Expanded(child: GraphVoltage(refString: "sensor_1_data")),
                ],
              ),
            ),
            Expanded(
                child:
                    Expanded(child: GraphVibration(refString: "sensor_1_data")))
          ],
        ));
  }
}


// MediaQuery.of(context).size.width < 640
//           // ignore: prefer_const_constructors
//           ? const Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   children: [
//                     TemperatureGuage(
//                       refString: "sensor_1_data",
//                     ),
//                     HumidityGauge(
//                       refString: "sensor_1_data",
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     VoltageGraph(
//                       refString: "sensor_1_data",
//                     ),
//                     GraphTemp(
//                       refString: "sensor_1_data",
//                     )
//                   ],
//                 ),
//               ],
//             )
//           : const Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   children: [
//                     TemperatureGuage(
//                       refString: "sensor_1_data",
//                     ),
//                     HumidityGauge(
//                       refString: "sensor_1_data",
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     VoltageGraph(
//                       refString: "sensor_1_data",
//                     ),
//                     GraphTemp(
//                       refString: "sensor_1_data",
//                     )
//                   ],
//                 ),
//               ],
//             ),