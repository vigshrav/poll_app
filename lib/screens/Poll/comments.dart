import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/models/userObjs.dart';
import 'package:polling_app/services/fire_users.dart';
import 'package:polling_app/screens/Poll/getComments.dart';
import 'package:polling_app/widgets/spinner.dart';

class CommentsPage extends StatefulWidget {

  final docID, question;
  CommentsPage(this.docID, this.question);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {

  final textfieldcontroller = TextEditingController();
  var usrcomments = '';
  
  @override
  Widget build(BuildContext context) {

    addComment(currUser) async {
      await FirebaseFirestore.instance.collection('polls').doc(widget.docID).collection('comments').add({
        'comments': usrcomments,
        'user': currUser,
        'createdDate': DateTime.now(),
      });
      await FirebaseFirestore.instance.collection('polls').doc(widget.docID).update({
        'comments': FieldValue.increment(1)
      });
      textfieldcontroller.clear();
    }

    return StreamBuilder<UserObjs>(
      stream: UserServices(uid: user!.uid).userRootData,
      builder: (context,snapshot){
        UserObjs? userObjs = snapshot.data;
        if (snapshot.hasData){
          var currUser = userObjs!.uName;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: CloseButton(color: Colors.black,),
            backgroundColor: Colors.white,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width - (MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right), 
                (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom)) *0.05,
                ),
              child: Padding(padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 30.0),
              child: Center(child: Text(widget.question, overflow: TextOverflow.ellipsis, style: GoogleFonts.openSans(color: HexColor('#2D7A98'), fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center,)),)
            ),
          ),
          body: GestureDetector(
        onTap: () => {
          FocusScope.of(context).unfocus(),
        },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey),),),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: textfieldcontroller,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(icon: Icon(Icons.send), color: HexColor('#2D7A98'), onPressed: () async { addComment(currUser); },),
                                  hintText: 'Share your views here ..',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: HexColor('#2D7A98'), 
                                    ),
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 2.0,
                                  ),
                                  ),
                                ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  onChanged: (val) {
                                    setState(() => {
                                      usrcomments = val
                                    });
                                    //print(val);
                                  }
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom)) * 0.75,
                    child: SingleChildScrollView(
                      child: GetComments(widget.docID)
                    ),
                  ),
                  
                    
              ],),
            ),
          ),
          // bottomNavigationBar: Container(
          //         //height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom)) * 0.1,
          //         decoration: BoxDecoration(border: Border.all( color: Colors.grey), ),
          //         child: TextFormField(
          //           decoration: InputDecoration(
          //             suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: (){}, color: HexColor('#2D7A98'),),
          //             labelText: 'Start Typing Here ..'),
          //             keyboardType: TextInputType.multiline,
          //             maxLines: 1,
          //             onChanged: (val) {
          //               setState(() => {});
          //             }
          //         ),
          //       ),
        );
        } else return Loading();
      }
    );
  }
}