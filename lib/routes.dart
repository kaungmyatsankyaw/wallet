import 'package:flutter/material.dart';
import 'package:wallet/screens/login.dart';
import 'package:wallet/screens/splash.dart';

import 'constant/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SPLASH:
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));
      case LOGIN:
        return MaterialPageRoute(builder: ((context) => const Login()));
      default:
        return MaterialPageRoute(builder: (context) => const ErrorRoute());
    }
  }
}

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Something went wrong!!',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ));
  }
}
