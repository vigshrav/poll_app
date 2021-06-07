import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/widgets/bottomNav.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;

    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double safeAreaVertical = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    double safeBlockVertical = (screenHeight - safeAreaVertical);
    
    double screenWidth = size.width;
    double safeAreaHorizontal = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;
    double safeBlockHorizontal = (screenWidth - safeAreaHorizontal);

    int tabindex = 3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor('#2D7A98'),
        title: Text('Notifications', style: GoogleFonts.openSans(fontSize: 30.0) ,),
        centerTitle: true,
      ),
      body: SingleChildScrollView (
      child: Container(
      height: safeBlockVertical * 1,
      color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(height: safeBlockVertical * 0.9,
            
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('notifications').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  
                  if (!snapshot.hasData) return new Text('Loading...');
                  if (snapshot.data!.docs.length == 0) return Center(child: new Text('No notifications yet', style: GoogleFonts.openSans(fontSize: 20, color: HexColor('#2D7A98')),));
                  return ListView(
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        
                      return Container(
                        width: safeBlockHorizontal,
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
                                // CircleAvatar(backgroundColor: Colors.grey, radius: 25, backgroundImage: NetworkImage((document.data() as dynamic)['avatarURL']), ),
                                // SizedBox(width: 50,),
                                Text(('@ ${(document.data() as dynamic)['message']}'), style: GoogleFonts.openSans(fontSize: 16, color: HexColor('#2D7A98')),),
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
    ),
      bottomNavigationBar: BottomBar(tabindex),
    );
  }
}