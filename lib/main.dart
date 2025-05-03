import 'package:flutter/material.dart';

import 'vues/meduim_screen/home/home.dart';
import 'vues/meduim_screen/login/login.dart';
import 'vues/meduim_screen/sign_up/sign_up.dart';
import 'vues/meduim_screen/splash/splash.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyTravel',
      home: const Splash(),
      routes: {
        Login.path: (context) => const Login(),
        Splash.path: (context) => const Splash(),
        SignUp.path: (context) => const SignUp(),
        Home.path: (context) => const Home(),
        
        
      },
    );
  }
}
