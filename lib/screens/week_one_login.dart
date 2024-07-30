import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // input
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Mon 191 !!! อิอิ",
              style: TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                decoration: const InputDecoration(
                  border:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                  labelText: 'Enter your username',
                ),
              )
            ),
            ElevatedButton(
              onPressed: () {
                // alert user
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert Dialog'),
                      content: Text('Hello $username'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        )
                      ],
                    );
                  }
                );
              },
              child: const Text('TEST'),
            )
          ],
        )));
  }
}
