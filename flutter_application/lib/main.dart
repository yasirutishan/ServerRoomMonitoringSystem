import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  @override
  Widget build(BuildContext context) {
    final _dbRef = FirebaseDatabase.instance.ref('sensor_1_data');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),
      body: Column(children: [
        StreamBuilder(
          stream: _dbRef.onValue,
          builder: (context, snapshot) {
            List<String> messageList = [];
            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data!).snapshot.value != null) {
              final myMessages = Map<dynamic, dynamic>.from((snapshot.data!)
                  .snapshot
                  .value as Map<dynamic, dynamic>); //typecasting
              myMessages.forEach((key, value) {
                final currentMessage = Map<String, dynamic>.from(value);
                // messageList.add(Message(
                //     author: currentMessage['Author'],
                //     authorId: currentMessage['Author_ID'],
                //     text: currentMessage['Text'],
                //     time: currentMessage['Time'],));
              }); //created a class called message and added all messages in a List of class message
              return ListView.builder(
                reverse: true,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return const Text("data");
                  //
                  // ChattingDesign(
                  //   message: messageList[index],
                  //   dbpathToMsgChnl:
                  //       'TextChannels/${widget.channels['ChannelName']}/Messages',
                  //   showName: shouldShowName(
                  //     index,
                  //     messageList.length - 1,
                  //     messageList,
                  //   ),
                  // );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Say Hi...',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w400),
                ),
              );
            }
          },
        )
      ]
          // //Initialize the chart widget
          // SfCartesianChart(
          //   primaryXAxis: CategoryAxis(),
          //   // Chart title
          //   title: ChartTitle(text: 'Half yearly sales analysis'),
          //   // Enable legend
          //   legend: Legend(isVisible: true),
          //   // Enable tooltip
          //   tooltipBehavior: TooltipBehavior(enable: true),
          //   series: <ChartSeries<_SalesData, String>>[
          //     LineSeries<_SalesData, String>(
          //         dataSource: [
          //           _SalesData('Jan', 11),
          //           _SalesData('Feb', 28),
          //           _SalesData('Mar', 22),
          //           _SalesData('Apr', 32),
          //           _SalesData('May', 33),
          //           _SalesData('jun', 50),
          //           _SalesData('jul', 55),
          //           _SalesData('aug', 34),
          //           _SalesData('sep', 7),
          //           _SalesData('oct', 40),
          //           _SalesData('now', 66),
          //           _SalesData('dec', 9),
          //         ],
          //         xValueMapper: (_SalesData sales, _) => sales.year,
          //         yValueMapper: (_SalesData sales, _) => sales.sales,
          //         name: 'Sales',
          //         // Enable data label
          //         dataLabelSettings: const DataLabelSettings(isVisible: true))
          //   ],
          // ),

          ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
