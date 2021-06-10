import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:polling_app/screens/Poll/addnewpoll.dart';
import 'package:polling_app/screens/Poll/pollsList.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/widgets/bottomNav.dart';
import 'package:polling_app/widgets/spinner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int tabindex=1;

  bool loading = false;

  User? user = FirebaseAuth.instance.currentUser;

  int filtertabindex = 1;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UserObjs>(
      stream: UserServices(uid: user!.uid).userRootData,
      builder: (context,snapshot){
        UserObjs? userObjs = snapshot.data;
        if (snapshot.hasData){
          var currUser = userObjs!.uName;
          var avatarURL = userObjs.avatarURL;
          List blockedUsers = userObjs.blockedUsers;
          return loading ? Loading() : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[HexColor('#2D7A98'), HexColor('#81AFC1')],
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              title: 
              //Container(width: 50, height: 50, child: Image.asset('assets/icon-48.png', fit: BoxFit.cover,)),
              //Text('Wootin', style: GoogleFonts.openSans(fontSize: 30.0) ,),
              Stack(
                children: [
                  Image.asset('assets/app_top_bar.png'),
                  Center(child: Text('', style: GoogleFonts.openSans(fontSize: 30.0) ,)),
                  ],
              ),
                
              centerTitle: true,
              actions: [
                // IconButton(onPressed: () async {setState(() {loading = true;});await AuthService().signOut();}, icon: Icon(Icons.logout)),
                // IconButton(onPressed: () async {await SystemNavigator.pop();}, icon: Icon(Icons.power_settings_new)),
              ],
            ),
            
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                //height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom)*0.85,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      ElevatedButton.icon(
                        onPressed: (){
                          setState(() {
                            filtertabindex = 1;
                          });
                        }, 
                        icon: iconColor(filtertabindex, 1), 
                        label: Text('Open Polls'), 
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                        )
                      ),
                        backgroundColor: MaterialStateProperty.all<Color>(buttonColor(filtertabindex, 1)),
                      ),
                      ),
                      SizedBox(width: 4.0),
                      ElevatedButton.icon(
                        onPressed: (){
                          setState(() {
                            filtertabindex = 2;
                          });
                        }, 
                        icon: iconColor(filtertabindex, 2), 
                        label: Text('Closed Polls',),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                        )
                      ),
                        backgroundColor: MaterialStateProperty.all<Color>(buttonColor(filtertabindex, 2)),
                      )),
                      SizedBox(width: 4.0),
                      ElevatedButton.icon(
                        onPressed: (){
                          if (filtertabindex == 3){
                            setState(() {
                              filtertabindex = 4;
                            });
                          } else {
                            setState(() {
                              filtertabindex = 3;
                            });
                          }
                        }, 
                        icon: iconColor(filtertabindex, 3), 
                        label: Text('Most Voted'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                        )
                      ),
                        backgroundColor: MaterialStateProperty.all<Color>(buttonColor(filtertabindex, 3)),
                      )),
                    ],),
                    Divider(thickness: 2.0,),
                    PollsList(currUser, filtertabindex, blockedUsers),
                  ],
                )
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

Icon iconColor(int filterindex, buttonindex){
  if (filterindex == buttonindex && filterindex < 3) {
    return Icon(Icons.check, color: Colors.white);
  } else if (filterindex == 3 && buttonindex == 3) {
    return Icon(Icons.arrow_downward, color: Colors.white);
    } else if (filterindex == 4 && buttonindex == 3) {
      return Icon(Icons.arrow_upward, color: Colors.white);
      } else return Icon(Icons.clear, color: Colors.white);
}

Color buttonColor(int filterindex, buttonindex){
  if ((filterindex == buttonindex) || (filterindex == 4 && buttonindex == 3)) {
    return HexColor('#2D7A98');
  } else {return Colors.grey;}
}

