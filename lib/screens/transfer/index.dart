import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/models/user.dart';
import 'package:wallet/networkstatus.dart';
import 'package:wallet/screens/transfer_wallet.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  NetworkStatus? networkStatus;

  @override
  void initState() {
    super.initState();
    networkStatus = NetworkStatus();
  }

  @override
  void dispose() {
    networkStatus?.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transfer'),
      ),
      body: StreamBuilder<ConnectivityResult>(
          stream: networkStatus?.networkStatusController.stream,
          builder: (_, snapshot) {
            if (snapshot.data == ConnectivityResult.none) {
              return const Center(
                child: Text(
                  'Offline !!. You cannot transfer at this time',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }
            // if(snapshot.connectionState == 'active')
            return const TransferScrren();
          }),
    );
  }
}

const storage = FlutterSecureStorage();

class TransferScrren extends StatefulWidget {
  const TransferScrren({super.key});

  @override
  State<TransferScrren> createState() => _TransferScrrenState();
}

class _TransferScrrenState extends State<TransferScrren> {
  String? user_id;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      user_id = await storage.read(key: 'user_id');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.docs;

          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = User.fromMap(users[index].data());
                return ListTile(
                  onTap: () {
                    if (user.id == user_id) {
                      return;
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => TransferWallet(transferUser: user)));
                  },
                  leading: const Icon(Icons.person),
                  title: Text(user.name!),
                );
              }
              // },
              );
        });
  }
}
