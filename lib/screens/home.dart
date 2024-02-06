import 'package:flutter/material.dart';
import 'package:wallet/screens/history/index.dart';
import 'package:wallet/screens/profile/index.dart';
import 'package:wallet/screens/transfer/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [ const Profile(), const Transfer(), const History()][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.people),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.history)),
            label: 'Transfer',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
