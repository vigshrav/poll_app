import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/Tabbar/home.dart';
import 'package:polling_app/widgets/spinner.dart';

class AddNewPoll extends StatefulWidget {

  final uname, avatarURL;
  AddNewPoll(this.uname, this.avatarURL);

  @override
  _AddNewPollState createState() => _AddNewPollState();
}

class _AddNewPollState extends State<AddNewPoll> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  var visible = [false, false, false, false, false, false, false];

  var visindex = 0;

  late String pollTitle, choice1, choice2, pollDur; 
  late String choice3;
  String choice4 = '';
  String choice5 = '';
  String choice6 = '';
  String choice7 = '';
  String choice8 = '';
  String choice9 = '';
  String choice10 = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    User user = FirebaseAuth.instance.currentUser!;

    validateduration(val){
      if (int.parse(val)<=0 || int.parse(val)>130){
        return ('Duration should be between 1 and 130');
      } else return null;
    }

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#2D7A98'),
        title: Text('Add New Poll', style: GoogleFonts.openSans(fontSize: 30.0) ,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.phone, color: Colors.,),
                        labelText: 'Enter Your Poll Question Here',
                        labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(width: 2.0, color: Colors.black45)
                        ),
                      ),
                      maxLength: 300,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                      onChanged: (val) {
                        setState(() => pollTitle = val);
                      }
                    ),
                    SizedBox(height: 30.0,),
                    TextFormField(
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                        labelText: 'Choice 1',
                        labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(width: 2.0, color: Colors.black45)
                        ),
                      ),
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      validator: (val) => val!.isEmpty ? 'Min 2 choices are required' : null,
                      onChanged: (val) {
                        setState(() => choice1 = val);
                      }
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                        labelText: 'Choice 2',
                        labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(width: 2.0, color: Colors.black45)
                        ),
                      ),
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      validator: (val) => val!.isEmpty ? 'Min 2 choices are required' : null,
                      onChanged: (val) {
                        setState(() => choice2 = val);
                      }
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                        labelText: 'Choice 3',
                        labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(width: 2.0, color: Colors.black45)
                        ),
                      ),
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                      onChanged: (val) {
                        setState(() => choice3 = val);
                      }
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[0],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 4',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice4 = val);
                        }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[1],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 5',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice5 = val);
                        }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[2],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 6',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice6 = val);
                        }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[3],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 7',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                       // validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice7 = val);
                        }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[4],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 8',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice8 = val);
                        }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[5],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 9',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice9 = val);
                        }
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(visible: visible[6],
                      child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                          labelText: 'Choice 10',
                          labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0),),
                            borderSide: BorderSide(width: 2.0, color: Colors.black45)
                          ),
                        ),
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        //validator: (val) => val!.isEmpty ? 'Please provide a valid phone number to login' : null,
                        onChanged: (val) {
                          setState(() => choice10 = val);
                        }
                      ),
                    ),
                    //SizedBox(height: 15,),
                    SizedBox(height: 15,),
                    TextFormField(
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                        labelText: 'Poll Duration (max 130 days)',
                        labelStyle: GoogleFonts.openSans(color: HexColor('#2D7A98'),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0),),
                          borderSide: BorderSide(width: 2.0, color: Colors.black45)
                        ),
                      ),
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'Please enter a value between 1 and 130' : validateduration(val),
                      onChanged: (val) {
                        setState(() => pollDur = val);
                      }
                    ),
                    SizedBox(height: 15,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50, width: 180,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: HexColor('#2D7A98'))
                                ))),
                            child: Text('+ Add Choice', style: GoogleFonts.openSans(fontSize: 18, color: HexColor('#2D7A98'))), 
                            onPressed: (){
                              setState(() {
                                visible[visindex] = true;
                                visindex = visindex+1;
                              });
                            }
                          )
                        ),
                      
                        Container(
                          height: 50, width: 180,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(HexColor('#2D7A98')),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  //side: BorderSide(color: Colors.red)
                                ))),
                            child: Text('Save & Publish', style: GoogleFonts.openSans(fontSize: 18)), 
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              await _firestore.collection('polls').add({
                                'pollTitle' : pollTitle,
                                'pollDur': pollDur,
                                'choice1': choice1,
                                'choice2': choice2,
                                'choice3': choice3,
                                'choice4': choice4,
                                'choice5': choice5,
                                'choice6': choice6,
                                'choice7': choice7,
                                'choice8': choice8,
                                'choice9': choice9,
                                'choice10': choice10,
                                'option1val': 0.0,
                                'option2val': 0.0,
                                'option3val': 0.0,
                                'option4val': 0.0,
                                'option5val': 0.0,
                                'option6val': 0.0,
                                'option7val': 0.0,
                                'option8val': 0.0,
                                'option9val': 0.0,
                                'option10val': 0.0,
                                'creationDate': DateTime.now(),
                                'createdByID': user.uid,
                                'creatoruname': widget.uname,
                                'creatoravatarURL': widget.avatarURL,
                                'comments': 0,
                                'likes': 0,
                                'dislikes': 0,
                                'votes': 0,
                                'resultset': {},
                                'likedby': ['none', 'none'],
                                'unlikedby': ['none', 'none']
                              });
                              await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                                'polls': FieldValue.increment(1)
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                            }
                          )
                        ) 
                      ],
                    ), 
                  ]
                )
              )
            ])
        ),
      )
    );
  }
}