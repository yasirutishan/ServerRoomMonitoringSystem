import 'package:firebase_auth/firebase_auth.dart';
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
          FloatingActionButton.extended(
            label: const Text('Sign Out'), // <-- Text
            icon: const Icon(
              Icons.logout,
              size: 24.0,
            ),
            onPressed: signUserOut,
          ),
          const SizedBox(
            height: 10,
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
                        builder: (context) => AddUserPage(),
                      ),
                    );
                  },
                )
              : const Text("")
        ],
      ),
    );
  }
}
