import 'package:flutter/material.dart';
import 'package:trip/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          centerTitle: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Click Button To Navigate to Any Page",
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ...MyAppRoutes.values
                .map(
                  (route) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.red,
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, route.value);
                      },
                      child: Text(route.name),
                    ),
                  ),
                )
                .toList(),
          ],
        ));
  }
}
