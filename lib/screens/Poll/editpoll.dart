import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/Poll/pollsList.dart';
import 'package:polling_app/screens/Tabbar/home.dart';
import 'package:polling_app/widgets/spinner.dart';

class EditPoll extends StatefulWidget {

  final PollContent data;
  EditPoll(this.data);

  @override
  _EditPollState createState() => _EditPollState();
}

class _EditPollState extends State<EditPoll> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  var visible = [false, false, false, false, false, false, false];

  var visindex = 0;

  late String pollTitle, choice1, choice2, choice3, choice4, choice5, choice6, choice7, choice8, choice9, choice10;
  late int pollDur;
  int newPollDur = 0;

@override
void initState(){

  pollTitle = widget.data.pollTitle; 
  choice1 = widget.data.choice1; 
  choice2 = widget.data.choice2; 
  choice3 = widget.data.choice3;
  choice4 = widget.data.choice4;
  choice5 = widget.data.choice5;
  choice6 = widget.data.choice6;
  choice7 = widget.data.choice7;
  choice8 = widget.data.choice8;
  choice9 = widget.data.choice9;
  choice10 = widget.data.choice10;
  pollDur = widget.data.pollDur;

  super.initState();
}
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    //User user = FirebaseAuth.instance.currentUser!;

    List months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var trimEndDate = widget.data.pollEndDt;
    var enDt = "${trimEndDate.day}";
    var enMnth = "${trimEndDate.month}";
    var enMnthName = months[int.parse(enMnth)-1];
    var enYear = "${trimEndDate.year}";

    validateduration(val){
      if (int.parse(val)<=0 || int.parse(val)>130){
        return ('Duration should be between 1 and 130');
      } else return null;
    }

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#2D7A98'),
        automaticallyImplyLeading: false,
        title: Row(mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),),);}, icon: Icon(Icons.clear)),
            SizedBox(width: 10.0,),
            Text('Edit Poll', style: GoogleFonts.openSans(fontSize: 30.0) ,),
          ],
        ),
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
                      initialValue: pollTitle,
                      decoration: InputDecoration(
                        labelText: 'Question:',
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
                      validator: (val) => val!.isEmpty ? 'Poll Title cannot be empty' : null,
                      onChanged: (val) {
                        setState(() => pollTitle = val);
                      }
                    ),
                    SizedBox(height: 30.0,),
                    TextFormField(
                      initialValue: choice1,
                      decoration: InputDecoration(
                        labelText: 'Choice #1:',
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
                      initialValue: choice2,
                      decoration: InputDecoration(
                        labelText: 'Choice #2:',
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
                      initialValue: choice3,
                      decoration: InputDecoration(
                        labelText: 'Choice #3:',
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
                    // Visibility(visible: visible[0],
                    //   child: 
                    TextFormField(
                      initialValue: choice4,
                      decoration: InputDecoration(
                        labelText: 'Choice #4:',
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
                      //),
                    ),
                    SizedBox(height: 15,),
                    // Visibility(visible: visible[1],
                    //   child: 
                    TextFormField(
                      initialValue: choice5,
                        decoration: InputDecoration(
                          labelText: 'Choice #5:',
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
                    //),
                    SizedBox(height: 15,),
                    // Visibility(visible: visible[2],
                    //   child: 
                    TextFormField(
                      initialValue: choice6,
                        decoration: InputDecoration(
                          labelText: 'Choice #6:',
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
                    //),
                    SizedBox(height: 15,),
                    // Visibility(visible: visible[3],
                    //   child: 
                    TextFormField(
                      initialValue: choice7,
                        decoration: InputDecoration(
                          labelText: 'Choice #7:',
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
                    // ),
                    SizedBox(height: 15,),
                    // Visibility(visible: visible[4],
                    //   child: 
                    TextFormField(
                      initialValue: choice8,
                        decoration: InputDecoration(
                          labelText: 'Choice #8:',
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
                    // ),
                    SizedBox(height: 15,),
                    // Visibility(visible: visible[5],
                    //   child: 
                    TextFormField(
                      initialValue: choice9,
                        decoration: InputDecoration(
                          labelText: 'Choice #9:',
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
                    // ),
                    SizedBox(height: 15,),
                    // Visibility(visible: visible[6],
                    //   child: 
                    TextFormField(
                      initialValue: choice10,
                        decoration: InputDecoration(
                          labelText: 'Choice #10:',
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
                    // ),
                    //SizedBox(height: 15,),
                    SizedBox(height: 15,),
                    TextFormField(
                      //initialValue: pollDur.toString(),
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.phone, color: Colors.orange,),
                        labelText: 'Poll End Date: $enDt $enMnthName $enYear',
                        hintText: 'Extend End Date by',
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
                        setState(() => newPollDur = int.parse(val));
                      }
                    ),
                    SizedBox(height: 15,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(
                        //   height: 50, width: 180,
                        //   child: ElevatedButton(
                        //     style: ButtonStyle(
                        //       backgroundColor: MaterialStateProperty.all(Colors.white),
                        //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //         RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(20.0),
                        //           side: BorderSide(color: HexColor('#2D7A98'))
                        //         ))),
                        //     child: Text('+ Add Choice', style: GoogleFonts.openSans(fontSize: 18, color: HexColor('#2D7A98'))), 
                        //     onPressed: (){
                        //       setState(() {
                        //         visible[visindex] = true;
                        //         visindex = visindex+1;
                        //       });
                        //     }
                        //   )
                        // ),
                      
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
                            child: Text('Update', style: GoogleFonts.openSans(fontSize: 18)), 
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                              setState(() {
                                loading = true;
                              });
                              var duration = newPollDur + pollDur;
                              await _firestore.collection('polls').doc(widget.data.pollID).update({
                                'pollTitle' : pollTitle,
                                'pollDur': duration,
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
                                'closingDate' : widget.data.pollStDt.add(Duration(days: duration)),
                                'lastModifiedDate': DateTime.now(),
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                            }}
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