import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _screens = [
    Container(
      alignment: Alignment.center,
      child: const Text(
        "Home",
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Text(
        "Temperature",
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Text(
        "Humidity",
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Text(
        "Voltage",
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Text(
        "Vibrations",
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: const Text(
        "Settings",
        style: TextStyle(fontSize: 40),
      ),
    )
  ];

  int _selectedIndex = 0;
// sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.cyan[400],
              unselectedItemColor: Colors.grey,
              // showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.storage), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.thermostat), label: "Temperature"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit), label: "Humidity"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.offline_bolt), label: "Voltage"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.stacked_line_chart), label: "Vibrations"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Settings"),
              ],
              onTap: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            NavigationRail(
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.storage), label: Text("Home")),
                NavigationRailDestination(
                    icon: Icon(Icons.thermostat), label: Text("Temperature")),
                NavigationRailDestination(
                    icon: Icon(Icons.ac_unit), label: Text("Humidity")),
                NavigationRailDestination(
                    icon: Icon(Icons.offline_bolt), label: Text("Voltage")),
                NavigationRailDestination(
                    icon: Icon(Icons.stacked_line_chart),
                    label: Text("Vibrations")),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text("Settings")),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              labelType: NavigationRailLabelType.all,
              leading: Column(
                children: [
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 30,
                    child: Image.asset("/images/logo.png"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          Expanded(child: _screens[_selectedIndex])
        ],
      ),
    );
  }
}
