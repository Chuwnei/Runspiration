import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:runspiration/size_config.dart';
import 'package:runspiration/healthAPI.dart';
import 'package:runspiration/shared/singleton.dart';
import 'package:health/health.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // TextEditingController emailcontroller = TextEditingController();
  final _singleton = Singleton();

  final _healthAPI = HealthAPI();

  // call HealthAPI's fetchdata function to get the list of healthdatapoints
  @override
  Widget build(BuildContext context) {
    _healthAPI.fetchData();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF14181B),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/fabio-comparelli-uq2E2V4LhCY-unsplash.jpg',
                ).image,
                opacity: 0.5),
          ),
          child: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/Android_Icon.png', height: 150),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Runspiration",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 5,
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
                    ])),
          ),
        ));
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

  String? newEmail;
  String? newPassword;
  String? newConfirm;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Form(
              key: _formKey,
              child: Column(children: [
                const Align(
                  alignment: Alignment(0.0, 0),
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'Sign In',
                      ),
                      Tab(
                        text: 'Sign Up',
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // email
                      // const Text("Email", style: TextStyle(fontSize: 15)),
                      TextFormField(
                        // initialValue: 'Input text',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "name@example.com",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 24.0, 20.0, 24.0),
                        ),
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
                      const SizedBox(height: 10),
                      // const Text("Password", style: TextStyle(fontSize: 15)),
                      TextFormField(
                        // initialValue: 'Input text',
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 24.0, 20.0, 24.0)),
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

                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 70,
                          height: 65,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 12, 198, 170)),
                            onPressed: () {
                              Authentication()
                                  .signin(email, password)
                                  .then((value) {
                                print("HERE IS THE VALUE: $value");
                                if (value != null) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/', (route) => false);
                                }
                              });
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
                      TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      // TextButton(
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, "/signup");
                      //     },
                      //     child: const Text("Sign Up",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white))),
                      // ButtonBar(
                      //   alignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     TextButton(
                      //         onPressed: () {},
                      //         child: const Text("Forgot Password?",
                      //             style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.white))),
                      //     const SizedBox(width: 100),
                      //     TextButton(
                      //         onPressed: () {
                      //           Navigator.pushNamed(context, "/signup");
                      //         },
                      //         child: const Text("Sign Up",
                      //             style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.white))),
                      //   ],
                      // )
                    ],
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // email
                      // const Text("Email", style: TextStyle(fontSize: 15)),
                      TextFormField(
                        // initialValue: 'Input text',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "name@example.com",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 24.0, 20.0, 24.0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() => newEmail = value),
                        style: const TextStyle(
                            fontSize: 22, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const SizedBox(height: 10),
                      // const Text("Password", style: TextStyle(fontSize: 15)),
                      TextFormField(
                        // initialValue: 'Input text',
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 24.0, 20.0, 24.0)),
                        obscureText: _obscureText,
                        onChanged: (value) =>
                            setState(() => newPassword = value),
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
                      const SizedBox(height: 10),
                      // const Text("Password", style: TextStyle(fontSize: 15)),
                      TextFormField(
                        // initialValue: 'Input text',
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confirm Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 24.0, 20.0, 24.0)),
                        obscureText: _obscureText,
                        onChanged: (value) =>
                            setState(() => newConfirm = value),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          } else if (value != newPassword) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                        style: const TextStyle(
                            fontSize: 22, color: Color.fromARGB(255, 0, 0, 0)),
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 70,
                          height: 65,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 12, 198, 170)),
                            onPressed: (_formKey.currentState != null &&
                                    _formKey.currentState!.validate())
                                ? () {
                                    Authentication()
                                        .signup(newEmail, newPassword)
                                        .then((value) {
                                      print("HERE IS THE VALUE: $value");
                                      if (value != null) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/', (route) => false);
                                      }
                                    });
                                    // Navigator.pushNamed(context, '/mainscreen');
                                  }
                                : null,
                            child: const Text(
                              "Create Account",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]))
              ]),
            )));
  }
}
