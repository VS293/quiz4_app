import 'package:flutter/material.dart';

import 'package:quiz4_app/shared/constant.dart';
import 'package:quiz4_app/services/auth.dart';
import 'package:quiz4_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.gif"),
                    fit: BoxFit.cover)),
            child: Loading())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              elevation: 5,
              title: Text("Sign In"),
              actions: [
                ElevatedButton.icon(
                  icon: Icon(Icons.person),
                  label: Text("Register"),
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.gif"),
                      fit: BoxFit.cover)),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) =>
                          val!.isEmpty ? "Enter an Email" : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Password"),
                      validator: (val) => val!.length < 6
                          ? "Enter a password with atleast 6 digits"
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: btnStyle,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);

                                if (result == null) {
                                  setState(() {
                                    error =
                                        "could not sign in with those credentials ";
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child: Text("sign in ")),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        Text("or"),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        ElevatedButton(
                            style: btnStyle,
                            onPressed: () async {
                              dynamic result = await _auth.signInAnon();
                              print(result);
                            },
                            child: Text("sign in anonymously"))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
