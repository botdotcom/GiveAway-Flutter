import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:give_away/screens/login_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:give_away/components/rounded_button.dart';
import 'package:give_away/constants.dart';
import 'package:give_away/screens/feed_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  Color color = Colors.red[300];
  Color textColor = Colors.white;
  bool showProgressSpinner = false;

  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showProgressSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/ga_icon.png'),
                    ),
                  )
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kLoginInputTextFieldDecoration.copyWith(hintText: 'Enter email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kLoginInputTextFieldDecoration.copyWith(hintText: 'Enter password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Register',
                  color: color,
                  textColor: textColor,
                  onPressed: () async {
                    setState(() {
                      showProgressSpinner = true;
                    });
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);

                      if (newUser != null) {
                        Navigator.pushNamed(context, LoginScreen.id);
                      }

                      setState(() {
                        showProgressSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  }
              ),
            ],
          ),
        ),
      )
    );
  }
}