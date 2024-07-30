import 'package:flutter/material.dart';
import 'package:trip/routes.dart';
import 'package:trip/screens/tripDetailPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Project',
      theme: ThemeData(
        useMaterial3: true,
        // primarySwatch: Colors.deepOrange,
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Colors.blueAccent,
        //   titleTextStyle: TextStyle(
        //     color: Colors.white,
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   centerTitle: false,
        // ),
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
      ),
      initialRoute: '/trip_login_page',
      routes: getRoutes(),
      onGenerateRoute: (settings) {
        // Handling dynamic route for tripDetailPage
        if (settings.name != null &&
            settings.name!.startsWith(MyAppRoutes.tripDetailPage.value)) {
          final uri = Uri.parse(settings.name!);
          final idx = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
          if (idx != null) {
            return MaterialPageRoute(
              builder: (context) => TripDetailPage(idx: int.parse(idx)),
              settings: settings,
            );
          }
        }
        // Return null for the system to use `onUnknownRoute`
        return null;
      },
    );
  }
}
