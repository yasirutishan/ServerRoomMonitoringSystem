import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                  GaugeDisplay(
                    refString: "sensor_1_data",
                    vital: 'temperature',
                  ),
                  GaugeDisplay(
                    refString: "sensor_1_data",
                    vital: 'humidity',
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GaugeDisplay(
                    refString: "sensor_1_data",
                    vital: 'temperature',
                  ),
                  GaugeDisplay(
                    refString: "sensor_1_data",
                    vital: 'humidity',
                  ),
                ],
              ));
  }
}

class GuageMeter extends StatefulWidget {
  const GuageMeter({super.key, required this.gaugeName});

  final String gaugeName;

  @override
  State<GuageMeter> createState() => _GuageMeterState();
}

class _GuageMeterState extends State<GuageMeter> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container());
  }
}
