import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallet/constant/routes.dart';
import 'package:wallet/providers/user_provider.dart';
import 'package:wallet/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late User? user;

  Future<User?> checkAuth() async {
    await Future.delayed(const Duration(seconds: 5));
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            user = snapshot.data; // Direct assignment without setState

            if (user != null) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(HOME, (route) => false);
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LOGIN, (route) => false);
              // if (mounted) {
              //   setState(() {
              //     Navigator.of(context).pushAndRemoveUntil(
              //       MaterialPageRoute(builder: (_) => const Login()),
              //       (route) => false,
              //     );
              //   });
              // }
            }
            return const SizedBox();
          }
        },
      ),
    );
  }
}
