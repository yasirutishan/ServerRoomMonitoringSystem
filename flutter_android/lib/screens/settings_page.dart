import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android/screens/add_user_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var showAddUser =
        FirebaseAuth.instance.currentUser!.email!.startsWith('admin@');

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SettingsForm(),
          const SizedBox(
            height: 30,
          ),
          showAddUser
              ? FloatingActionButton.extended(
                  label: const Text('Add New User'), // <-- Text
                  icon: const Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUserPage(),
                      ),
                    );
                  },
                )
              : const Text(""),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            label: const Text('Sign Out'), // <-- Text
            icon: const Icon(
              Icons.logout,
              size: 24.0,
            ),
            onPressed: signUserOut,
          ),
        ],
      ),
    );
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({
    super.key,
  });

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  int _hum = 90;
  int _smoke = 1950;
  int _tem = 40;
  int _volH = 264;
  int _volL = 200;
  String _mail = "10749896@students.plymouth.ac.uk";

  @override
  void initState() {
    super.initState();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final settings = {
        'hum': _hum,
        'smoke': _smoke,
        'tem': _tem,
        'volH': _volH,
        'volL': _volL,
        'mail': _mail
      };
      // Do something with the settings, e.g. save them to a database
      print(settings);
      final databaseReference = FirebaseDatabase.instance.ref();
      databaseReference.child('get').set(settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            TextFormField(
              initialValue: _hum.toString(),
              decoration: const InputDecoration(
                labelText: 'Humidity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                _hum = int.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _smoke.toString(),
              decoration: const InputDecoration(
                labelText: 'Smoke',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                _smoke = int.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _tem.toString(),
              decoration: const InputDecoration(
                labelText: 'Temperature',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                _tem = int.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _volH.toString(),
              decoration: const InputDecoration(
                labelText: 'High Voltage',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                _volH = int.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _volL.toString(),
              decoration: const InputDecoration(
                labelText: 'Low Voltage',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                _volL = int.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _mail.toString(),
              decoration: const InputDecoration(
                labelText: 'Email Address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                // if (RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                //     .hasMatch(value)) {
                //   return 'Please enter a valid Email';
                // }
                return null;
              },
              onChanged: (value) {
                _mail = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              label: const Text('Save Parameters'),
              icon: const Icon(
                Icons.save,
                size: 24.0,
              ),
              onPressed: _saveSettings,
            ),
          ],
        ),
      ),
    );
  }
}
