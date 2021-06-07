import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:polling_app/screens/Poll/addnewpoll.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/widgets/bottomNav.dart';
import 'package:polling_app/widgets/pollslist.dart';
import 'package:polling_app/widgets/spinner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int tabindex=1;

  bool loading = false;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UserObjs>(
      stream: UserServices(uid: user!.uid).userRootData,
      builder: (context,snapshot){
        UserObjs? userObjs = snapshot.data;
        if (snapshot.hasData){
          var currUser = userObjs!.uName;
          var avatarURL = userObjs.avatarURL;
          return loading ? Loading() : Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor('#2D7A98'),
              automaticallyImplyLeading: false,
              title: Text('Wootter Poll', style: GoogleFonts.openSans(fontSize: 30.0) ,),
              centerTitle: true,
              actions: [
                // IconButton(onPressed: () async {setState(() {loading = true;});await AuthService().signOut();}, icon: Icon(Icons.logout)),
                // IconButton(onPressed: () async {await SystemNavigator.pop();}, icon: Icon(Icons.power_settings_new)),
              ],
            ),
            
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom)*0.9,
                child: PollsList(currUser)
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewPoll(currUser, avatarURL)
                  ));
              },
              backgroundColor: HexColor('#2D7A98'),
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomBar(tabindex),
          );
        } else return Loading();
      });
  }
}