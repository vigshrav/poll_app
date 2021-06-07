import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:polling_app/screens/Auth/signin.dart';
import 'package:polling_app/screens/tabbar/home.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //User? user = FirebaseAuth.instance.currentUser;

  handleAuth() {
    //print(user!.uid);
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home()
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SignIn()
          );
        }
      });
  }

  // sign in
  Future signIn(AuthCredential creds) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(creds);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign up
  Future signUp(AuthCredential creds, uname, phno, email) async {
    
  }

  // otp verification
  signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  // otp verification
  signUpWithOTP(smsCode, verId, uname, phno, email) async {
    try {
    AuthCredential authCreds = PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    
      await FirebaseAuth.instance.signInWithCredential(authCreds).then((user) async => {
        // ignore: unnecessary_null_comparison
        if (user != null)
          {
          //store registration details in firestore database
          await _firestore
            .collection('users')
            .doc(user.user!.uid)
            .set({
              'usrname': uname,
              'phno': phno.toString().trim(),
              'email': email,
              'polls': 0,
              'followers': 0,
              'following': 0,
              'avatarURL': ''
            }),
          }
      });


    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
      
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

}
