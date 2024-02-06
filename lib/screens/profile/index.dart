import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wallet/models/user.dart';
import 'package:wallet/providers/user_provider.dart';
import 'package:wallet/screens/splash.dart';
import 'package:wallet/widgets/logout-btn.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

const storage = FlutterSecureStorage();

class _ProfileState extends State<Profile> {
  String? user_id;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      user_id = await storage.read(key: 'user_id');
      print(user_id);
      setState(() {});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .get()
          .then((value) {
        if (value.exists) {
          Provider.of<UserProvider>(context, listen: false).setUser(
            User.fromMap(value.data()! as Map<String, dynamic>),
          );
        } else {
          print('User document does not exist');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user_id)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text('User not found'),
                );
              }

              User user =
                  User.fromMap(snapshot.data!.data()! as Map<String, dynamic>);

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person),
                              Text(user.name ?? ''),
                            ],
                          ),
                          Text(
                            '${user.amount ?? 0} SGD',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          LogOutBtn(),
        ],
      ),
    );
  }
}
