import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class GetComments extends StatefulWidget {
  final docid;
  GetComments(this.docid);
  @override
  _GetCommentsState createState() => _GetCommentsState();
}

class _GetCommentsState extends State<GetComments> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('polls').doc(widget.docid).collection('comments').orderBy('createdDate', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');

        return Container(
          height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom))*0.75,
          child: ListView(
            reverse: false,
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                return Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey), ),),
                    child: ListTile(
                      title: Row(children: [
                        Text('@', style: GoogleFonts.openSans(color: HexColor('#2D7A98'), fontWeight: FontWeight.bold),),
                        Text('${(document.data() as dynamic)['user']}', style: GoogleFonts.openSans(color: HexColor('#2D7A98'), fontWeight: FontWeight.bold),),
                      ]),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('${(document.data() as dynamic)['comments']}', style: GoogleFonts.openSans(color: Colors.black,),),
                      ),
                    ),
                );
              }).toList()
            )
          );
      }
    );
  }
}