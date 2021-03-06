import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:give_away/screens/item_detail_screen.dart';

import 'package:give_away/screens/login_screen.dart';
import 'package:give_away/screens/main_app_screen.dart';
import 'package:give_away/screens/registration_screen.dart';
import 'package:give_away/screens/welcome_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GiveAwayApp());
}

class GiveAwayApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GiveAway HackApp',
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        MainAppScreen.id: (context) => MainAppScreen(),
        ItemDetailScreen.id: (context) => ItemDetailScreen()
      },
    );
  }
}
