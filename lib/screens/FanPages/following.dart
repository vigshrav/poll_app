import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/widgets/spinner.dart';

class Following extends StatefulWidget {
  const Following({ Key? key }) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double safeAreaVertical = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    double safeBlockVertical = (screenHeight - safeAreaVertical);

    // return StreamBuilder<UserObjs>(
    //   stream: UserServices(uid: user!.uid).userRootData,
    //   builder: (context,snapshot){
    //     UserObjs? userObjs = snapshot.data;
    //     if (snapshot.hasData){
    //       var currUser = userObjs!.uName;

          return SingleChildScrollView (
            child: Container(
            height: safeBlockVertical * 1,
            color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(height: safeBlockVertical * 0.9,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //var projList = snapshot.data.documents;
                        if (!snapshot.hasData) return new Text('Loading...');
                        if (snapshot.data!.docs.length == 0) return Center(child: new Text('You are following no one yet', style: GoogleFonts.openSans(fontSize: 20, color: HexColor('#2D7A98')),));
                        return ListView(
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                              
                            return Container(
                              //height: 49,
                              decoration: BoxDecoration( 
                                          border: Border(bottom: BorderSide(color: Colors.grey),),
                                          
                                        ),
                              //child: Card( 
                                child: ListTile(
                                  title: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(backgroundColor: Colors.grey, radius: 20, backgroundImage: NetworkImage((document.data() as dynamic)['avatarURL']), ),
                                      SizedBox(width: 50,),
                                      Text(('@ ${(document.data() as dynamic)['uname']}'), overflow: TextOverflow.ellipsis, style: GoogleFonts.openSans(fontSize: 16, color: HexColor('#2D7A98')),),
                                    ])
                                )
                            );
                            }
                          ).toList()
                        );
                      }
                  )
                  )
                ])
            )                   
          );
    //     } else return Loading();
    //   }
    // );

  }
}