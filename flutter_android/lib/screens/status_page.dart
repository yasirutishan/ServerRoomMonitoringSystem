import 'package:flutter/material.dart';
import '../widgets/gauges.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MediaQuery.of(context).size.width < 640
            // ignore: prefer_const_constructors
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TemperatureGuage(
                    refString: "sensor_1_data",
                  ),
                  HumidityGauge(
                    refString: "sensor_1_data",
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TemperatureGuage(
                    refString: "sensor_1_data",
                  ),
                  HumidityGauge(
                    refString: "sensor_1_data",
                  ),
                ],
              ));
  }
}
