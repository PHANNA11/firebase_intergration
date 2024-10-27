import 'package:firebase_app/view/auth/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/intergration_firebase.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final cpassController = TextEditingController();
  bool hindPassword = true;
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
                  obscureText: hindPassword,
                  controller: passController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hindPassword = !hindPassword;
                            });
                          },
                          child: hindPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: hindPassword,
                  controller: cpassController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hindPassword = !hindPassword;
                            });
                          },
                          child: hindPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'confirm password'),
                ),
              ),
              CupertinoButton(
                color: Colors.blueAccent,
                child: const Text('Register'),
                onPressed: () async {
                  if (emailController.text.isNotEmpty ||
                      passController.text.isNotEmpty ||
                      cpassController.text.isNotEmpty) {
                    if (cpassController.text == passController.text) {
                      await FirebaseController()
                          .registerUserAccount(
                              email: emailController.text.trim(),
                              password: passController.text.trim())
                          .then((value) {
                        if (value != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                              (route) => false);
                        }
                      });
                    }
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
