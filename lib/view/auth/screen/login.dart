import 'package:firebase_app/view/auth/firebase/intergration_firebase.dart';
import 'package:firebase_app/view/auth/screen/sign_up.dart';
import 'package:firebase_app/view/store/screen/home_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                    image: NetworkImage(
                        'https://img.freepik.com/premium-photo/ai-generated-images-create-userfriendly-login-page_1290175-100.jpg?size=626&ext=jpg')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'E-mail'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: passController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'password'),
                  ),
                ),
                CupertinoButton(
                  color: Colors.blueAccent,
                  child: const Text('LogIn'),
                  onPressed: () async {
                    await FirebaseController()
                        .loginUser(
                            email: emailController.text.trim(),
                            password: passController.text.trim())
                        .then((value) {
                      if (value != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeStoreScreen(),
                            ),
                            (route) => false);
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterAccountScreen(),
              ));
        },
        child: Container(
          height: 35,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.blue),
          child: Center(
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
