import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:my_app/backend_services/auth.dart';

class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String email = '';
  String password = '';
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
                  const Text("Sign In", style: TextStyle(fontSize: 20)),
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
                  ElevatedButton(
                    onPressed: () {
                      Authentication().signin(email, password);
                      Navigator.pushNamed(context, '/mainscreen');
                    },
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Or use google"),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?")),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: const Text("Sign Up")),
                    ],
                  )
                ])));
  }
}
