import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/Auth/signup.dart';
import 'package:polling_app/services/fire_auth.dart';
import 'package:polling_app/widgets/spinner.dart';


class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();

  final verID;
  final String type, uname, phno, email;

  OTP(this.verID, this.type, this.uname, this.phno, this.email);
}

class _OTPState extends State<OTP> {

  final _formKey = GlobalKey<FormState>();
  
  late String otpkey, verificationId;
  
  String error = '';

  bool codeSent = false;
  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor('#2D7A98'),
        title: Text('Enter OTP', style: GoogleFonts.openSans(fontSize: 30.0) ,),
        centerTitle: true,),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.orange,),
                      labelText: 'Enter OTP',
                      labelStyle: GoogleFonts.openSans(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0),),
                        borderSide: BorderSide(width: 2.0, color: Colors.black45)
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.isEmpty ? 'Please OTP sent to your phone' : null,
                    onChanged: (val) {
                      setState(() => otpkey = val);
                    }
                  ),
                  // SizedBox(height: 20,),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     prefixIcon: Icon(Icons.vpn_key, color: Colors.orange,),
                  //     labelText: 'password',
                  //     labelStyle: GoogleFonts.openSans(color: Colors.green),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(25.0),),
                  //       borderSide: BorderSide(color: Colors.grey)
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(25.0),),
                  //       borderSide: BorderSide(width: 2.0, color: Colors.black45)
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.text,
                  //   obscureText: true,
                  //   validator: (val) => val!.isEmpty ? 'Please provide a password' : null,
                  //   onChanged: (val) {
                  //     setState(() => password = val);
                  //   }
                  // ),
                  Text('$error', style: TextStyle(color: Colors.red)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange),),
                    child: Text('Confirm'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      if (widget.type == 'signin') {
                        await AuthService().signInWithOTP(otpkey, widget.verID);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      } else {
                        await AuthService().signUpWithOTP(otpkey, widget.verID, widget.uname, widget.phno, widget.email);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    }
                  ),
                  TextButton(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New User?', style: TextStyle(color: Colors.black54),),
                        SizedBox(width: 5.0,),
                        Text('Register', style: TextStyle(color: Colors.orange),),
                      ],
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUp())
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
}