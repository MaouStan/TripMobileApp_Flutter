import 'package:flutter/material.dart';
import 'package:trip/screens/menu.dart';
import 'package:trip/screens/tripDetailPage.dart';
import 'package:trip/screens/tripHomePage.dart';
import 'package:trip/screens/tripRegisterPage.dart';
import 'package:trip/screens/week_one_login.dart';
import 'package:trip/screens/tripLoginPage.dart';
import 'package:trip/screens/week_two_first.dart';

import 'screens/tripProfilePage.dart';

enum MyAppRoutes {
  menu('/'),
  login('/login'),
  weekTwoFirstPage('/week2_first_page'),
  tripLoginPage('/trip_login_page'),
  tripHomePage('/trip_home_page'),
  tripRegisterPage('/trip_register_page'),
  tripProfilePage('/trip_profile_page'),
  tripDetailPage('/trip_detail_page');

  final String value;
  const MyAppRoutes(this.value);
}

Map<String, WidgetBuilder> getRoutes() => {
      for (final route in MyAppRoutes.values)
        if (route != MyAppRoutes.tripDetailPage)
          route.value: (context) => switch (route) {
                MyAppRoutes.menu => const HomePage(),
                MyAppRoutes.login => const LoginPage(),
                MyAppRoutes.weekTwoFirstPage => const WeekTwoFirstPage(),
                MyAppRoutes.tripLoginPage => const TripLoginPage(),
                MyAppRoutes.tripHomePage =>throw UnimplementedError(),
                MyAppRoutes.tripRegisterPage => const TripRegisterPage(),
                MyAppRoutes.tripProfilePage => throw UnimplementedError(),
                // Remove tripDetailPage from here since it's handled separately below
                MyAppRoutes.tripDetailPage => throw UnimplementedError(),
              },
      // Handle tripDetailPage separately to include dynamic path
      '${MyAppRoutes.tripDetailPage.value}/:idx': (context) {
        final idx = ModalRoute.of(context)?.settings.arguments as int?;
        return TripDetailPage(idx: idx!);
      },
      '${MyAppRoutes.tripProfilePage.value}': (context) {
        final cid = ModalRoute.of(context)?.settings.arguments as int?;
        return TripProfilePage(cid: cid!,);
      },
      '${MyAppRoutes.tripHomePage.value}': (context) {
        final cid = ModalRoute.of(context)?.settings.arguments as int?;
        return TripHomePage(cid: cid!,);
      },
    };
