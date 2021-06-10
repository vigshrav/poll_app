import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/FanPages/searchUserProfile.dart';
import 'package:polling_app/screens/Tabbar/fanspage.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({ Key? key }) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {

  User? user = FirebaseAuth.instance.currentUser;
  var searchController = TextEditingController();

  bool isFollowing = false;

  List searchRes = [];

  var searchKey = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double safeAreaVertical = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    double safeBlockVertical = (screenHeight - safeAreaVertical);

    bool avatarImgavailable = true;

    searchQuery(){      
      if (searchKey == '') {
        return FirebaseFirestore.instance.collection('users').snapshots();
        } else {
          return FirebaseFirestore.instance.collection('users').orderBy('usrname').startAt([searchKey]).endAt([searchKey + '\uf8ff']).snapshots();
          }
    }
  
    return Container(height: safeBlockVertical * 0.9,
      child: Column(
        children: [
          Container(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: TextField(controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search new users',
                hintStyle: GoogleFonts.openSans(fontSize: 22.0),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => {
                if (val.length >= 3) {
                  setState(() {
                    searchKey = val;
                  })
                } else {
                  setState(() {
                    searchKey = '';
                  }),
                },
                //print (searchKey)
              },
            ),
          ),
          SizedBox(height: 15.0),
          SingleChildScrollView (
            child: Container(height: safeBlockVertical * 0.79,
            child: StreamBuilder(
                stream: searchQuery(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //var projList = snapshot.data.documents;
                  if (!snapshot.hasData) return new Text('Loading...');
                  return ListView(
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        if ((document.data() as dynamic)['avatarURL'] == '') {avatarImgavailable = false;} else {avatarImgavailable = true;}
                      return Container(
                        //height: 49,
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey),),),
                        //child: Card( 
                          child: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                avatarImgavailable ? CircleAvatar(backgroundColor: Colors.grey,radius: 20.0, backgroundImage: NetworkImage((document.data() as dynamic)['avatarURL']),) : CircleAvatar(backgroundColor: Colors.grey,radius: 20.0,child: Icon(Icons.account_circle, size: 40.0, color: Colors.black54),),
                                SizedBox(width: 20,),
                                Text(('@ ${(document.data() as dynamic)['usrname']}'), overflow: TextOverflow.ellipsis, style: GoogleFonts.openSans(fontSize: 16, color: HexColor('#2D7A98')),),
                              ]),
                              onTap: () async {

                                if (document.id != user!.uid) {

                                  await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').get().then((querySnapshot) => {
                                    if (querySnapshot.docs.isNotEmpty){
                                      searchRes.clear(),
                                      querySnapshot.docs.forEach((doc) => {
                                        if (document.id == doc.id) {
                                          isFollowing = true
                                        } else {isFollowing = false}
                                      })
                                    }
                                  });

                                  final data = SearchResData(resUseruid: document.id, currUseruid: user!.uid, isFollowing: isFollowing);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SearchProfilePage(data)));
                                  //searchController.clear();
                                } else {

                                  displaySnackBar('You can access your profile from the profile tab.');
                                  //searchController.clear();

                              //},
                            }})
                      );
                      }
                    ).toList()
                  );
                }
            )
            )                   
          ),
        ],
      ),
    );
  }
   displaySnackBar(errtext) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errtext),
        duration: const Duration(seconds: 3),
      ));
  }
}