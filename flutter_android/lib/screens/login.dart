import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<void> signUserIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) => null)
        .onError((error, stackTrace) => showDialog(
              context: context,
              builder: (context) => Center(
                child: AlertDialog(
                  title: const Text(
                      'The e-mail address and password did not match.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Try Again'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ))
        .whenComplete(() => null);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 400,
          child: Column(children: [
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 200,
              child: Image.asset("assets/images/logo.png"),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: false,
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    signUserIn();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Log In"),
                  )),
            )
          ]),
        ),
      ),
    ));
  }
}

// fallen*1050