import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:david_app/size_config.dart';

class Login extends StatelessWidget {
  Login({super.key});

  // TextEditingController emailcontroller = TextEditingController();
  // TextEditingController passwordcontroller = TextEditingController();
  // String email = '';
  // String password = '';
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
                  const Text("Runspiration",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 100,
                  ),
                  LoginForm()
                  // const Text("Email", style: TextStyle(fontSize: 15)),
                  // TextField(
                  //   controller: emailcontroller,
                  //   decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: "name@example.com"),
                  //   onChanged: (text) {
                  //     email = text;
                  //   },
                  // ),
                  // const SizedBox(height: 50),
                  // const Text("Password", style: TextStyle(fontSize: 15)),
                  // TextField(
                  //   controller: passwordcontroller,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   onChanged: (text) {
                  //     password = text;
                  //   },
                  //   obscureText: true,
                  // ),
                  // const SizedBox(height: 50),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Authentication().signin(email, password);
                  //     // Navigator.pushNamed(context, '/mainscreen');
                  //   },
                  //   child: const Text("Sign In"),
                  // ),
                  // const SizedBox(height: 30),
                  // // ElevatedButton(
                  // //   onPressed: () {},
                  // //   child: const Text("Or use google"),
                  // // ),
                  // ButtonBar(
                  //   alignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     TextButton(
                  //         onPressed: () {},
                  //         child: const Text("Forgot Password?")),
                  //     TextButton(
                  //         onPressed: () {
                  //           Navigator.pushNamed(context, "/signup");
                  //         },
                  //         child: const Text("Sign Up")),
                  //   ],
                  // )
                ])));
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // email
          const Text("Email", style: TextStyle(fontSize: 15)),
          TextFormField(
            // initialValue: 'Input text',
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "name@example.com"),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) => setState(() => email = value),
            style: const TextStyle(
                fontSize: 22, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 50),
          const Text("Password", style: TextStyle(fontSize: 15)),
          TextFormField(
            // initialValue: 'Input text',
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Password"),
            obscureText: _obscureText,
            onChanged: (value) => setState(() => password = value),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            style: const TextStyle(
                fontSize: 22, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          // password

          const SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: SizeConfig.blockSizeHorizontal! * 50,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  Authentication().signin(email, password).then((value) =>
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false));
                  // Navigator.pushNamed(context, '/mainscreen');
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: const Text("Or use google"),
          // ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                  onPressed: () {}, child: const Text("Forgot Password?")),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup");
                  },
                  child: const Text("Sign Up")),
            ],
          )
        ],
      ),
    );
  }
}
