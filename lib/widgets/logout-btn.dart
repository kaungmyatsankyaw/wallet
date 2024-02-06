import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/constant/routes.dart';
import 'package:wallet/screens/splash.dart';

class LogOutBtn extends StatelessWidget {
  const LogOutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              const storage = FlutterSecureStorage();
              await storage.deleteAll();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LOGIN, (route) => false);
            },
            child: const Text('Log Out')));
  }
}
