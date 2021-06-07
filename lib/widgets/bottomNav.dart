
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:polling_app/screens/Tabbar/fanspage.dart';
import 'package:polling_app/screens/Tabbar/notifications.dart';
import 'package:polling_app/screens/Tabbar/usrprofile.dart';
import 'package:polling_app/screens/Tabbar/home.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/widgets/spinner.dart';


class BottomBar extends StatelessWidget {
  
  final int tabindex;
  BottomBar(this.tabindex);

  @override
  Widget build(BuildContext context) {

  var user = FirebaseAuth.instance.currentUser;

  // return StreamBuilder<UserObjs>(
  //     stream: UserServices(uid: user!.uid).userRootData,
  //     builder: (context,snapshot){
  //       UserObjs? userObjs = snapshot.data;
  //       if (snapshot.hasData){
  //         //var currUser = userObjs!.uName;
  //         var avatarImgURL = userObjs!.avatarURL;
  //         bool avatarImgavailable;

  //         if (avatarImgURL != '') {avatarImgavailable = true;} else {avatarImgavailable = false;}

  void _showHome(BuildContext context) async {
    await Navigator.pushAndRemoveUntil(
      context, 
      PageRouteBuilder(pageBuilder: (_, __, ___) => Home()
      ), 
     ModalRoute.withName("/")
    );
  }

  Future _showFans(BuildContext context) async {
    await Navigator.pushAndRemoveUntil(
      context, 
      PageRouteBuilder(pageBuilder: (_, __, ___) => FansPage()
      ), 
     ModalRoute.withName("/")
    );
  }

  Future _showNotifs(BuildContext context) async {
    await Navigator.pushAndRemoveUntil(
      context, 
      PageRouteBuilder(pageBuilder: (_, __, ___) => NotificationsPage()
      ), 
     ModalRoute.withName("/")
    );
  }

  Future _showProfile(BuildContext context) async {
    await Navigator.pushAndRemoveUntil(
      context, 
      PageRouteBuilder(pageBuilder: (_, __, ___) => ProfilePage(),
      ), 
     ModalRoute.withName("/")
    );
  }

    return BottomAppBar(
      elevation: 20.0,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.home), color: _tab1IconColor(tabindex), iconSize: _tab1IconSize(tabindex), onPressed: () => _showHome(context),),
                  IconButton(icon: Icon(Icons.people_alt), color: _tab2IconColor(tabindex), iconSize: _tab2IconSize(tabindex), onPressed: () => _showFans(context),),
                
                  IconButton(icon: Icon(Icons.notifications), color: _tab3IconColor(tabindex), iconSize: _tab3IconSize(tabindex), onPressed: () => _showNotifs(context),),
                  IconButton(icon: Icon(Icons.menu), color: _tab4IconColor(tabindex), iconSize: _tab4IconSize(tabindex), onPressed: () => _showProfile(context),),
                  //IconButton(icon:getusrpfileimg(avatarImgURL), color: _tab4IconColor(tabindex), iconSize: _tab4IconSize(tabindex), onPressed: () => _showProfile(context)),
                  // GestureDetector(onTap: ()=> _showProfile(context), child: avatarImgavailable ? CircleAvatar(backgroundColor: Colors.grey, radius: _tab4IconSize(tabindex), 
                  // backgroundImage: NetworkImage(avatarImgURL), ) : CircleAvatar(backgroundColor: Colors.grey, radius:_tab4IconSize(tabindex), child: Icon(Icons.account_circle, size: 100.0,),),),
                ],
              )
            ),
          ]
        )
      )
    );
  // } else return Loading();
  //     });}
  }
}

double _tab1IconSize(tabindex) {
  if (tabindex == 1) {return 36.0;}
  else return 30.0;
}

Color _tab1IconColor(tabindex) {
  if (tabindex == 1) {return HexColor('#2D7A98');}
  else return Colors.black54;
}

double _tab2IconSize(tabindex) {
  if (tabindex == 2) {return 30.0;}
  else return 24.0;
}

Color _tab2IconColor(tabindex) {
  if (tabindex == 2) {return HexColor('#2D7A98');}
  else return Colors.black54;
}

double _tab3IconSize(tabindex) {
  if (tabindex == 3) {return 30.0;}
  else return 26.0;
}

Color _tab3IconColor(tabindex) {
  if (tabindex == 3) {return HexColor('#2D7A98');}
  else return Colors.black54;
}

double _tab4IconSize(tabindex) {
  if (tabindex == 4) {return 30.0;}
  else return 26.0;
}

Color _tab4IconColor(tabindex) {
  if (tabindex == 4) {return HexColor('#2D7A98');}
  else return Colors.black54;
}

