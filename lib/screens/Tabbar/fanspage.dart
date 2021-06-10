import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/FanPages/allContacts.dart';
import 'package:polling_app/screens/FanPages/followers.dart';
import 'package:polling_app/screens/FanPages/following.dart';
import 'package:polling_app/widgets/bottomNav.dart';

class FansPage extends StatefulWidget {
  @override
  _FansPageState createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
  
  late String usersearchtxt = "";
  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {

    int navindex = 2;
    int _tabindex = 0;
    //bool isFollowing = false;

    //List searchRes = [];
    
  return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: HexColor('#2D7A98'),
        //   automaticallyImplyLeading: false,
        //   elevation: 0.0,
         // title: Padding(
         //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 35),
           // child: TypeAheadField(
          //   textFieldConfiguration: TextFieldConfiguration(
          //     autofocus: false,
          //     style: GoogleFonts.openSans(color: Colors.white, fontSize: 20),
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(Icons.search, color: Colors.white,),
          //       border: OutlineInputBorder(borderSide: BorderSide.none),
          //       hintText: 'Find Someone New ...',
          //       hintStyle: GoogleFonts.openSans(color: Colors.white, fontSize: 20),),
          //   ),
          //   suggestionsCallback: (pattern) async {
          //     return await BackendService.getSuggestions(pattern);
          //   },
          //   itemBuilder: (context, Map<String, String> suggestion) {
          //     //print(suggestion['name']);
          //     return ListTile(
          //       //leading: Icon(Icons.shopping_cart),
          //       title: Text(suggestion['name']!),
          //       //subtitle: Text('\$${suggestion['price']}'),
          //     );
          //   },
          //   onSuggestionSelected: (Map<String, String> suggestion) async {
              
          //     var res = suggestion.values.toList();
          //     //print('ONCLICK: $res');
          //     await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('following').get().then((querySnapshot) => {
          //       if (querySnapshot.docs.isNotEmpty){
          //         searchRes.clear(),
          //         querySnapshot.docs.forEach((doc) => {
          //           if (res[1] == doc.id) {
          //             isFollowing = true
          //           }
          //         })
          //       }
          //     });

          //     if (res[1] != user!.uid) {

          //       final data = SearchResData(resUseruid: res[1], currUseruid: user!.uid, isFollowing: isFollowing);

          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => SearchProfilePage(data)));
                 
          //     } else {

          //       displaySnackBar('You can access your profile from the profile tab.');

          //     }
          //     //print(suggestion);
          //   },
          // ),
        
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: HexColor('#2D7A98'),
          automaticallyImplyLeading: false,
          title: new TabBar(
              tabs: [
                Tab(child: Text('Following', style: GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),),),
                Tab(child: Text('Followers', style: GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),),),
                Tab(child: Text('Contacts', style: GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),),),
              ],
              onTap: (index) {
                    setState(() => _tabindex = index);
              }
            )
          ),
        
        body:  
          // Column(
          //   children: [
          //     Container(
          //       //color: Theme.of(context).primaryColor,
          //       color: HexColor('#2D7A98'),
          //       height: 40.0,
          //       child: TabBar(
          //         //physics: NeverScrollableScrollPhysics(),
          //         indicatorColor: Theme.of(context).primaryColor,
          //         tabs: [
                    
          //           Tab(child: Text('Following', style: GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),),),
          //           Tab(child: Text('Followers', style: GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),),),
          //           Tab(child: Text('Contacts', style: GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),),),
                    
          //         ],
          //         onTap: (index) {
          //           setState(() => _tabindex = index);
          //         }
          //       ),
          //     ),
          //     Expanded(
          //       child: 
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    
                    Following(),
                    Followers(),
                    ContactsList()

                  ],
                ),
              //),
            //],
          //),
      bottomNavigationBar: BottomBar(navindex),
      //floatingActionButton: customFloatingActonButton(_tabindex, context),
    )
    );
  }


  // customFloatingActonButton(_tabindex, context){
  //   print(_tabindex);
  //   if (_tabindex == 0) { return null; } else {
  //       return FloatingActionButton(
  //         tooltip: 'Search New User',
  //           shape: StadiumBorder(),
  //           //backgroundColor: Colors.cyanAccent[400],
  //           onPressed: () async {
  //             await Navigator.of(context).push(new MaterialPageRoute(
  //             builder: (BuildContext context) {
  //               return new SearchUsers();
  //                 },
  //               ));
  //             }, 
  //       );
  //   }
  // }

  //  displaySnackBar(errtext) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(errtext),
  //       duration: const Duration(seconds: 3),
  //     ));
  // }

}

class SearchResData{
  String resUseruid, currUseruid; 
  bool isFollowing;

  SearchResData({required this.resUseruid, required this.currUseruid, required this.isFollowing});
}