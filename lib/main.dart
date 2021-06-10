import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:polling_app/services/fire_auth.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          duration: 2500,
          splash: 'assets/launch_image.gif',
          nextScreen: AuthService().handleAuth(),
          splashTransition: SplashTransition.fadeTransition,
          //ageTransitionType: PageTransitionType.scale,
          splashIconSize: 1200,
          backgroundColor: Colors.white
      )
    );
  }
}

