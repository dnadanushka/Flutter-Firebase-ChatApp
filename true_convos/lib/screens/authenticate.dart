import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_convos/services/auth.dart';
import '../globals.dart' as globals;

import '../res/screen_size_utils.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  bool isLogin;
  String error = '';
  String thisDeviceToken = '';

  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController passwordController;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) async {
      thisDeviceToken = deviceToken;
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  void initState() {
    isLogin = true;
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _getToken();
    _configureFirebaseListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 250),
                    if (!isLogin)
                      TextFormField(
                        controller: emailController,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Please fill in the email";
                          }
                          if (text.contains("@") && text.contains(".")) {
                            return null;
                          }
                          return "Invalid Email";
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          icon: Icon(
                            Icons.email,
                          ),
                        ),
                      ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: usernameController,
                      validator: (text) =>
                          text.isEmpty ? "Please fill in the username." : null,
                      decoration: InputDecoration(
                        hintText: "Username",
                        icon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: isLogin ? 24 : 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (text) =>
                          text.isEmpty ? "Please fill in the Password." : null,
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.lock_outline),
                      ),
                    ),
                    SizedBox(height: isLogin ? 24 : 20),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "FORGOT PASSWORD ?",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: isLogin ? 24 : 20),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) return;
                          _save(usernameController.text.trim());
                          if (isLogin) {
                            dynamic result =
                                await _auth.signInWithEmailAndPassword(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
                              context,
                            );
                            if (result == null) {
                              setState(() {
                                error =
                                    'could not sign in with those credentials';
                              });
                            }
                          } else {
                            globals.isReg = true;
                            dynamic result =
                                await _auth.registerWithEmailAndPass(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              usernameController.text.trim(),
                              thisDeviceToken,
                            );
                            
                            if (result == null) {
                              setState(() {
                                error = 'please supply a valid email';
                              });
                            }
                          }
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            isLogin ? "SIGN IN" : "SIGN UP",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 1.2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isLogin ? 32 : 24),
                    Container(
                      width: double.infinity,
                      child: InkWell(
                          onTap: () {
                            isLogin = !isLogin;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                isLogin
                                    ? "Don't have an account? "
                                    : "Already have an account? ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                isLogin ? "SIGN UP" : "SIGN IN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          UpperCurveBox(isLogin: isLogin),
        ],
      ),
    );
  }

  _save(String uname) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = uname;
    prefs.setString(key, value);
    print('saved $value');
  }
}

class UpperCurveBox extends StatelessWidget {
  final bool isLogin;
  const UpperCurveBox({
    Key key,
    this.isLogin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16),
              child: Text(
                "Trueconvos",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4),
              child: Text(
                "Join a Community or Interest",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 20),
              child: Text(
                "Talk to someone Instantly and Anonymously",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
