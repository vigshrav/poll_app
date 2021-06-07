import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:polling_app/services/fire_auth.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/widgets/bottomNav.dart';
import 'package:polling_app/widgets/spinner.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
  User? user = FirebaseAuth.instance.currentUser;
  var newemail = '';

  @override
  Widget build(BuildContext context) {

    int tabindex = 4;
    bool loading = false;

    return StreamBuilder<UserObjs>(
      stream: UserServices(uid: user!.uid).userRootData,
      builder: (context,snapshot){
        UserObjs? userObjs = snapshot.data;
        if (snapshot.hasData){
          var currUser = userObjs!.uName;
          var avatarImgURL = userObjs.avatarURL;
          bool avatarImgavailable;
          
          print(currUser);

          if (avatarImgURL != '') {avatarImgavailable = true;} else {avatarImgavailable = false;}

          return loading ? Loading() : Scaffold(
            backgroundColor: Colors.white,
            
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [HexColor('#2D7A98'), HexColor('#81AFC1')]
                      )
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                
                                displaySnackBar('Uploading your profile picture. Please hold on.');

                                final PickedFile? galImage = await ImagePicker().getImage(source: ImageSource.gallery);
                                final File image = File(galImage!.path);
                                firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child('users/profile/${user!.uid}/');
                                
                                firebase_storage.TaskSnapshot storageTaskSnapshot = await storageRef.putFile(image);
            
                                var profileImageUrl = await storageTaskSnapshot.ref.getDownloadURL();
            
                                //print(profileImageUrl);
            
                                await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                  'avatarURL' : profileImageUrl
                                });
                              },
            
                              child: avatarImgavailable
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 50.0,
                                    backgroundImage: NetworkImage(avatarImgURL),
                                  )
                                  : CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 50.0,
                                    child: Icon(Icons.account_circle, size: 100.0, color: Colors.black54),
                                  )
                                
                              // child: CircleAvatar(
                              //       radius: 50.0,
                              //       child: Icon(Icons.photo_camera),
                              //     ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "@ $currUser",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
            
                                        children: <Widget>[
                                          Text(
                                            "Polls",
                                            style: TextStyle(
                                              color: HexColor('#2D7A98'),
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "${userObjs.polls}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: HexColor('#81AFC1'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
            
                                        children: <Widget>[
                                          Text(
                                            "Followers",
                                            style: TextStyle(
                                              color: HexColor('#2D7A98'),
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "${userObjs.followers}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: HexColor('#81AFC1'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
            
                                        children: <Widget>[
                                          Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: HexColor('#2D7A98'),
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "${userObjs.following}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: HexColor('#81AFC1'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:40.0,horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            initialValue: userObjs.phone,
                            enabled: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone, color: HexColor('#2D7A98'),),
                              labelText: 'Mobile number',
                              labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0),),
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0),),
                                borderSide: BorderSide(width: 2.0, color: HexColor('#2D7A98'))
                              ),
                            ),
                            //maxLength: 10,
                            keyboardType: TextInputType.number,
                            validator: (val) => val!.isEmpty ? 'phone number cannot be empty' : null, //validateduration(val),
                            onChanged: (val) {
                              //setState(() => pollDur = val);
                            }
                          ),
                          SizedBox(height: 30.0,),
                          TextFormField(
                            initialValue: userObjs.eMail,
                            enabled: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail, color: HexColor('#2D7A98'),),
                              labelText: 'email',
                              labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0),),
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0),),
                                borderSide: BorderSide(width: 2.0, color: HexColor('#2D7A98'))
                              ),
                            ),
                            //maxLength: 10,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val!.isEmpty ? 'email cannot be empty' : validateEmail(val),
                            onChanged: (val) {
                              //setState(() => pollDur = val);
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 50, width: 180,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(HexColor('#2D7A98')),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              //side: BorderSide(color: Colors.red)
                            ))),
                        child: Text('Update', style: GoogleFonts.openSans(fontSize: 22)), 
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                        }
                      )
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 50, width: 180,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(HexColor('#2D7A98')),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              //side: BorderSide(color: Colors.red)
                            ))),
                        icon: Icon(Icons.logout),
                        label: Text('Sign Out', style: GoogleFonts.openSans(fontSize: 22)), 
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await AuthService().signOut();
                          //Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.pop(context);
                        }
                      )
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomBar(tabindex),
          );
        } else return Loading();
      }
    );
  }
    displaySnackBar(errtext) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errtext),
        duration: const Duration(seconds: 3),
      ));
  }
}

