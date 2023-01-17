import 'dart:html';

import 'package:flutter/material.dart';
import 'package:my_app/backend_services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  String email = '';
  String password = '';
  String confirm = '';
  bool match = false;
  void check_password(String password, String confirm) {
    if (password == confirm) {
      match = true;
    } else {
      match = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sign Up", style: TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text("Email", style: TextStyle(fontSize: 15)),
                  TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "name@example.com"),
                    onChanged: (text) {
                      email = text;
                    },
                  ),
                  const SizedBox(height: 50),
                  const Text("Password", style: TextStyle(fontSize: 15)),
                  TextField(
                    controller: passwordcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      password = text;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 50),
                  const Text("Confirm password",
                      style: TextStyle(fontSize: 15)),
                  TextField(
                    controller: confirm_password,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      confirm = text;
                      check_password(password, confirm);
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: match
                        ? () {
                            Authentication().signup(email, password);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text("Create Account"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Or use google"),
                  ),
                ])));
  }
}
