import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/Auth/otp.dart';
import 'package:polling_app/screens/Auth/signin.dart';
import 'package:polling_app/services/fire_auth.dart';
import 'package:polling_app/widgets/spinner.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  late String phoneNo, uname, email, verificationId, smsCode;

  //bool codeSent = false;
  bool loading = false;

  //To Validate email
  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }  
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: HexColor('#2D7A98'),
      //   title: Text('Register', style: GoogleFonts.openSans(fontSize: 30.0) ,),
      //   centerTitle: true,),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/login_signup_screen_logo.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(height: 50.0,),
            Form(key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email, color: HexColor('#2D7A98'),),
                      labelText: 'username',
                      labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(width: 2.0, color: Colors.black45)
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    //obscureText: true,
                    validator: (val) => val!.isEmpty ? 'Please provide a username' : null,
                    onChanged: (val) {
                      setState(() => uname = val);
                    }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail, color: HexColor('#2D7A98'),),
                      labelText: 'email',
                      labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(width: 2.0, color: Colors.black45)
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    //obscureText: true,
                    validator: (val) => val!.isEmpty ? 'Please provide an email id' : validateEmail(val),
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: HexColor('#2D7A98'),),
                      labelText: 'Phone Number',
                      labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(width: 2.0, color: Colors.black45)
                      ),
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                    onChanged: (val) {
                      setState(() => phoneNo = val);
                    }
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(HexColor('#2D7A98'),),),
                    child: Text('Register'),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){   
                        var chkphno = await _firestore.collection('users').where('phno', isEqualTo: '+91 '+phoneNo).get();
                        if(chkphno.docs.length == 0){                     
                          var chkusrname = await _firestore.collection('users').where('usrname', isEqualTo: uname).get();
                          var chkemail = await _firestore.collection('users').where('email', isEqualTo: email).get();
                          if (chkusrname.docs.length == 0 && chkemail.docs.length == 0) { 
                            setState(() {
                              loading = true;
                            });
                            var inPhoneNo = '+91 '+ phoneNo.trim();
                            await verifyPhone(inPhoneNo);
                          } else {
                            if (chkusrname.docs.length > 0 && chkemail.docs.length > 0){
                            displaySnackBar('username and email already in use');
                            } else if (chkusrname.docs.length > 0) {
                              displaySnackBar('username already in use');
                            } else if (chkemail.docs.length > 0) {
                              displaySnackBar('email already in use');
                            }
                          }
                        } else {displaySnackBar('Phone number already registered. Please use SignIn.');}
                      }
                    }
                  ),
                  TextButton(
                    child: Text('Sign In', style: TextStyle(color: HexColor('#2D7A98'),),),
                    onPressed: () async {
                      await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignIn())
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
  Future<void> verifyPhone(phoneNo) async {
    
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      _auth.signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      //print('${authException.message}');
      displaySnackBar('Validation error, please try again later');
    };

    final void Function(String verId, [int? forceResend]) smsSent = (String verId, [int? forceResend]) async {
      this.verificationId = verId;
      await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OTP(verId, 'signup', uname, phoneNo, email)));           
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        //timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  displaySnackBar(errtext) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errtext),
        duration: const Duration(seconds: 3),
      ));
  }


}