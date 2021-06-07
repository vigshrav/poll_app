import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:polling_app/screens/Tabbar/fanspage.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/widgets/spinner.dart';

class SearchProfilePage extends StatefulWidget {

  final SearchResData data;
  SearchProfilePage(this.data);

  @override
  _SearchProfilePageState createState() => _SearchProfilePageState();
}

class _SearchProfilePageState extends State<SearchProfilePage> {

  @override
  Widget build(BuildContext context) {

    //int tabindex = 4;
    bool loading = false;
    //bool isFollowing = false;

    print('YOU: ${widget.data.resUseruid}');
    print('SEARCH: ${widget.data.currUseruid}');

    return StreamBuilder<UserObjs>(
      stream: UserServices(uid: widget.data.currUseruid).userRootData,
      builder: (context,snapshot){
        UserObjs? curruserObjs = snapshot.data;
        if (snapshot.hasData){
          var currUsername = curruserObjs!.uName;
          var currUseravatarImgURL = curruserObjs.avatarURL;
          //bool avatarImgavailable;

          print('YOU: $currUsername');

          return StreamBuilder<UserObjs>(
            stream: UserServices(uid: widget.data.resUseruid).userRootData,
            builder: (context,snapshot){
              UserObjs? searchuserObjs = snapshot.data;
              if (snapshot.hasData){
                var searchUser = searchuserObjs!.uName;
                var searchUseravatarImgURL = searchuserObjs.avatarURL;
                bool avatarImgavailable;

                print('SEARCH: $searchUser');

                if (searchUseravatarImgURL != '') {avatarImgavailable = true;} else {avatarImgavailable = false;}

                return loading ? Loading() : Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0.0,
                    leading: CloseButton(color: Colors.white,),
                    backgroundColor: HexColor('#2D7A98'),
                  ),
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
                                      // final PickedFile? galImage = await ImagePicker().getImage(source: ImageSource.gallery);
                                      // final File image = File(galImage!.path);
                                      // firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child('users/profile/${user!.uid}/');
                                      
                                      // firebase_storage.TaskSnapshot storageTaskSnapshot = await storageRef.putFile(image);
                  
                                      // var profileImageUrl = await storageTaskSnapshot.ref.getDownloadURL();
                  
                                      // print(profileImageUrl);
                  
                                      // await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                      //   'avatarURL' : profileImageUrl
                                      // });
                                    },
                  
                                    child: avatarImgavailable
                                      ? CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: 50.0,
                                          backgroundImage: NetworkImage(searchUseravatarImgURL),
                                        )
                                        : CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: 50.0,
                                          child: Icon(Icons.account_circle, size: 100.0,),
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
                                    "@ $searchUser",
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
                                                  "${searchuserObjs.polls}",
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
                                                  "${searchuserObjs.followers}",
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
                                                  "${searchuserObjs.following}",
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
                        // Container(
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(vertical:40.0,horizontal: 16.0),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         SizedBox(height: 60.0, ),
                        //         //Text('Member since: xxxx', style: GoogleFonts.openSans(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic) )
                                
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 100.0,
                        ),
                        Visibility(visible: !widget.data.isFollowing,
                          child: Container(
                            height: 50, width: 180,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(HexColor('#2D7A98')),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      //side: BorderSide(color: Colors.red)
                                    ))),
                                child: Text('Follow', style: GoogleFonts.openSans(fontSize: 22)), 
                                onPressed: () async {
                                  setState(() { loading = true; });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.currUseruid).collection('following').doc(widget.data.resUseruid).set({
                                    'avatarURL': searchUseravatarImgURL,
                                    'uname': searchUser,
                                    'id' : widget.data.resUseruid,
                                  });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.resUseruid).collection('follower').doc(widget.data.currUseruid).set({
                                    'avatarURL': currUseravatarImgURL,
                                    'uname': currUsername,
                                    'id' : widget.data.currUseruid,
                                  });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.resUseruid).collection('notifications').add({
                                    'message': 'User $currUsername has started following you.',
                                    'createdOn': DateTime.now(),
                                  });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.currUseruid).update({
                                    'following': FieldValue.increment(1)
                                  });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.resUseruid).update({
                                    'followers': FieldValue.increment(1)
                                  });
                                  Navigator.pop(context);
                                }
                              )
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Visibility(visible: widget.data.isFollowing,
                          child: Container(
                            height: 50, width: 180,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(HexColor('#2D7A98')),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      //side: BorderSide(color: Colors.red)
                                    ))),
                                child: Text('Un-Follow', style: GoogleFonts.openSans(fontSize: 22)), 
                                onPressed: () async {
                                  setState(() { loading = true; });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.currUseruid).collection('following').doc(widget.data.resUseruid).delete();
                                  await FirebaseFirestore.instance.collection('users').doc(widget.data.resUseruid).collection('follower').doc(widget.data.currUseruid).delete();
                                  // await FirebaseFirestore.instance.collection('users').doc(widget.data.resUseruid).collection('notifications').add({
                                  //   'message': 'User $currUsername has un-followed you.',
                                  //   'createdOn': DateTime.now(),
                                  // });
                                  Navigator.pop(context);
                                }
                              )),
                        )
                        
                      ],
                    ),
                  ),
                  //bottomNavigationBar: BottomBar(tabindex),
                );
              } else return Loading();
            }
          );
        } else return Loading();
      });
  }
}