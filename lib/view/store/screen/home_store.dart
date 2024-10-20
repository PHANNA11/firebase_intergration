import 'package:firebase_app/view/auth/firebase/intergration_firebase.dart';
import 'package:firebase_app/view/auth/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeStoreScreen extends StatefulWidget {
  const HomeStoreScreen({super.key});

  @override
  State<HomeStoreScreen> createState() => _HomeStoreScreenState();
}

class _HomeStoreScreenState extends State<HomeStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: SafeArea(
              child: Column(
        children: [
          ListTile(
            onTap: () async {
              await FirebaseController().logOutUser().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogInScreen(),
                    ),
                    (route) => false);
              });
            },
            title: Text('Log Out'),
            trailing: Icon(Icons.logout),
          )
        ],
      ))),
      appBar: AppBar(
        title: Text('Store'),
      ),
    );
  }
}
