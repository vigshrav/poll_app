import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:polling_app/screens/Poll/comments.dart';
import 'package:polling_app/screens/Poll/editpoll.dart';
import 'package:polls/polls.dart';
import 'package:share/share.dart';

class PollsList extends StatefulWidget {

  final uname, filterindex, blockedUsers;
  PollsList(this.uname, this.filterindex, this.blockedUsers);

  @override
  _PollsListState createState() => _PollsListState();
}

class _PollsListState extends State<PollsList> {


  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    List blockedUsers = widget.blockedUsers;
    
    likeup(docid, usrList) async {
      await FirebaseFirestore.instance.collection('polls').doc(docid).update({
        'likes' : FieldValue.increment(1),
        'likedby': usrList
      });
    }
    likedown(docid, usrList) async {
      await FirebaseFirestore.instance.collection('polls').doc(docid).update({
        'likes' : FieldValue.increment(-1),
        'likedby': usrList
      });
    }

    dislikeup(docid, usrList) async {
      await FirebaseFirestore.instance.collection('polls').doc(docid).update({
        'dislikes' : FieldValue.increment(1),
        'unlikedby': usrList
      });
    }
    dislikedown(docid, usrList) async {
      await FirebaseFirestore.instance.collection('polls').doc(docid).update({
        'dislikes' : FieldValue.increment(-1),
        'unlikedby': usrList
      });
    }

    buildquery(){
      var query;
      switch(widget.filterindex) {
        
        case 1:
        query =  FirebaseFirestore.instance.collection('polls').orderBy('closingDate').where('closingDate', isGreaterThanOrEqualTo: DateTime.now()).orderBy('lastModifiedDate', descending: true).snapshots();
        break;
        
        case 2:
        query =  FirebaseFirestore.instance.collection('polls').orderBy('closingDate').where('closingDate', isLessThan: DateTime.now()).orderBy('lastModifiedDate', descending: true).snapshots();
        break;
        
        case 3:
        query =  FirebaseFirestore.instance.collection('polls').orderBy('votes', descending: false).snapshots();
        break;

        case 4:
        query =  FirebaseFirestore.instance.collection('polls').orderBy('votes', descending: true).snapshots();
        break;
      
      }
      return query;
    }

    var currUser = widget.uname;
    return StreamBuilder(
      stream: buildquery(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');

        return Container(
          height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom))*0.82,
          child: ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {

                // **** CHECK FOR BLOCKED USERS
                var creator = (document.data() as dynamic)['creatoruname'];

                bool pollVisibility = true;

                if (blockedUsers.contains(creator)) {pollVisibility = false;}

                // **** DURATION
                var age = DateTime.now().difference( DateTime.parse((document.data() as dynamic)['creationDate'].toDate().toString()) ).inDays;
                var remainingDays = ((document.data() as dynamic)['pollDur']) - age;
                
                // **** VOTES
                
                var votescount = (document.data() as dynamic)['votes'];

                // **** COMMENTS

                var commentscount = (document.data() as dynamic)['comments'];

                // **** LIKES

                var likescount = (document.data() as dynamic)['likes'];

                // **** DISLIKES

                var dislikescount = (document.data() as dynamic)['dislikes'];

                bool createdbyCurrUser = false;

                if (creator == currUser) {createdbyCurrUser = true;}

                List usersWhoLiked = (document.data() as dynamic)['likedby'];

                bool likeenabled = false;

                if (usersWhoLiked.contains(currUser)) {likeenabled = true;}

                List usersWhoUnLiked = (document.data() as dynamic)['unlikedby'];
                
                bool dislikeenabled = false;

                if (usersWhoUnLiked.contains(currUser)) {dislikeenabled = true;}

                bool avatarImgavailable = true;

                if ((document.data() as dynamic)['creatoravatarURL'] != '') {avatarImgavailable = true;} else {avatarImgavailable = false;}
              
              return Visibility(visible: pollVisibility,
                child: Container( //height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom)*0.04) ,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey),),),
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              avatarImgavailable
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 20,
                                      backgroundImage: NetworkImage((document.data() as dynamic)['creatoravatarURL']),
                                    )
                                    : CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 20.0,
                                      child: Icon(Icons.account_circle, size: 40.0, color: Colors.black54),
                                    ),
                              SizedBox(width: 10.0),
                              Text(createdbyCurrUser ? 'Posted by You' : '@ $creator'),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$remainingDays days to go'),
                            IconButton(onPressed: () async {
                              
                              await Share.share(createdbyCurrUser ? 
                              'Check out my new Poll: "'"${(document.data() as dynamic)['pollTitle']}"'" in the Wootin app - https://play.google.com/store/apps/details?id=com.vigshrav.wootin'
                              : 'I found an interesting poll: "'"${(document.data() as dynamic)['pollTitle']}"'" in the Wootin app - https://play.google.com/store/apps/details?id=com.vigshrav.wootin');
                            }, icon: Icon(Icons.share, size: 20,)),
                            Visibility(visible: !createdbyCurrUser,
                              child: PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(0.0),),
                                      label: Text('Block User', style: TextStyle(color: HexColor('#2D7A98'),)),
                                      icon: Icon(Icons.block, color: HexColor('#2D7A98'),),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        displaySnackBarWithOK('Block user and stop seeing polls from this user?', 'block', blockedUsers, creator);
                                      } 
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: ElevatedButton.icon( 
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(0.0),),
                                      label: Text('UnFollow', style: TextStyle(color: HexColor('#2D7A98'),)), 
                                      icon: Icon(Icons.person_off_rounded, color: HexColor('#2D7A98'),),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        displaySnackBarWithOK('Unfollow user and stop seeing polls from this user?', 'unfollow', blockedUsers, creator);
                                      }),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(0.0),),
                                      label: Text('Report', style: TextStyle(color: HexColor('#2D7A98'),),),
                                      icon: Icon(Icons.flag, color: HexColor('#2D7A98'),),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        displaySnackBarWithOK('Would you like to report this user or poll?', 'report', blockedUsers, creator);
                                      }),
                                  ),
                                  ]),
                            ),
                
                            // FLOWDOWN MENU FOR POLL CREATOR
                
                            Visibility(visible: createdbyCurrUser,
                              child: PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                    value: 1,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(0.0),),
                                      label: Text('Edit', style: TextStyle(color: HexColor('#2D7A98'),)),
                                      icon: Icon(Icons.edit, color: HexColor('#2D7A98'),),
                                      onPressed: () async {
                                        if (votescount > 0) {
                                          displaySnackBarNoButtons('This poll has votes already casted. This poll cannot be edited.');
                                        } else {
                                          final data = PollContent (
                                            pollID: document.id,
                                            pollTitle: (document.data() as dynamic)['pollTitle'],
                                            pollEndDt: DateTime.parse(document['closingDate'].toDate().toString()),
                                            pollStDt: DateTime.parse(document['creationDate'].toDate().toString()),
                                            pollDur: (document.data() as dynamic)['pollDur'],
                                            choice1: (document.data() as dynamic)['choice1'],
                                            choice2: (document.data() as dynamic)['choice2'],
                                            choice3: (document.data() as dynamic)['choice3'],
                                            choice4: (document.data() as dynamic)['choice4'],
                                            choice5: (document.data() as dynamic)['choice5'],
                                            choice6: (document.data() as dynamic)['choice6'],
                                            choice7: (document.data() as dynamic)['choice7'],
                                            choice8: (document.data() as dynamic)['choice8'],
                                            choice9: (document.data() as dynamic)['choice9'],
                                            choice10: (document.data() as dynamic)['choice10'],
                                          );
                                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPoll(data)));
                                      }
                                    }
                                  ),
                                ),
                                PopupMenuItem(
                                    value: 1,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(0.0),),
                                      label: Text('Delete', style: TextStyle(color: HexColor('#2D7A98'),)),
                                      icon: Icon(Icons.delete, color: HexColor('#2D7A98'),),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Permanently delete this poll?'),
                                          duration: const Duration(seconds: 4),
                                          action: SnackBarAction(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance.collection('polls').doc(document.id).delete();
                                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'polls': FieldValue.increment(-1)});
                                            },
                                          label: 'YES',
                                        )
                                      ));
                                    } 
                                  ),
                                ),
                              ]),
                            )
                          ],
                        ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      polls(document, currUser),
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$votescount Votes'),
                          Row(mainAxisSize: MainAxisSize.min ,
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up_alt), 
                              color: getlikecolor(likeenabled), 
                              onPressed: () async { 
                                if (likeenabled == true){
                                  setState(() {
                                    likeenabled = ! likeenabled;
                                  });
                                  usersWhoLiked.remove(currUser);
                                  await likedown(document.id, usersWhoLiked);
                                }else if (likeenabled == false){
                                  setState(() {
                                    likeenabled = ! likeenabled;
                                  });
                                  usersWhoLiked.add(currUser);
                                  await likeup(document.id, usersWhoLiked);
                                }
                                if(dislikeenabled == true){
                                  setState(() {
                                    dislikeenabled = false;
                                  });
                                  usersWhoUnLiked.remove(currUser);
                                  await dislikedown(document.id, usersWhoUnLiked);
                                }
                              },
                            ), 
                            SizedBox(width: 10,), 
                            Text('$likescount'), 
                            SizedBox(width: 30,), 
                            IconButton(
                              icon: Icon(Icons.thumb_down_alt), 
                              color: getdislikecolor(dislikeenabled), 
                              onPressed: () async {
                                if (dislikeenabled == true){
                                  setState(() {
                                    dislikeenabled = ! dislikeenabled;
                                  });
                                  usersWhoUnLiked.remove(currUser);
                                  await dislikedown(document.id, usersWhoUnLiked);
                                }else if (dislikeenabled == false){
                                  setState(() {
                                    dislikeenabled = ! dislikeenabled;
                                  });
                                  usersWhoUnLiked.add(currUser);
                                  await dislikeup(document.id, usersWhoUnLiked);
                                }
                                if(likeenabled == true){
                                  setState(() {
                                    likeenabled = false;
                                  });
                                  usersWhoLiked.remove(currUser);
                                  await likedown(document.id, usersWhoLiked);
                                }
                              },
                            ), 
                            SizedBox(width: 10,), 
                            Text('$dislikescount'),
                          ],),
                          Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsPage (document.id, (document.data() as dynamic)['pollTitle'])));
                              },
                            ), 
                            SizedBox(width: 5,), 
                            Text('$commentscount')])
                        ],
                      )
                    ],
                  )
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
  polls(document, currUser) {

    double optionval1, optionval2, optionval3, optionval4, optionval5, optionval6, optionval7, optionval8, optionval9, optionval10;

    String choice1, choice2, choice3, choice4, choice5, choice6, choice7, choice8, choice9, choice10;

      choice1 = (document.data() as dynamic)['choice1'];
      choice2 = (document.data() as dynamic)['choice2'];
      choice3 = (document.data() as dynamic)['choice3'];
      choice4 = (document.data() as dynamic)['choice4'];
      choice5 = (document.data() as dynamic)['choice5'];
      choice6 = (document.data() as dynamic)['choice6'];
      choice7 = (document.data() as dynamic)['choice7'];
      choice8 = (document.data() as dynamic)['choice8'];
      choice9 = (document.data() as dynamic)['choice9'];
      choice10 = (document.data() as dynamic)['choice10'];

      List choice = [choice1, choice2, choice3, choice4, choice5, choice6, choice7, choice8, choice9, choice10, ];
      
      optionval1 = (document.data() as dynamic)['option1val'] ;
      optionval2 = (document.data() as dynamic)['option2val'] ;
      optionval3 = (document.data() as dynamic)['option3val'] ;
      optionval4 = (document.data() as dynamic)['option4val'] ;
      optionval5 = (document.data() as dynamic)['option5val'] ;
      optionval6 = (document.data() as dynamic)['option6val'] ;
      optionval7 = (document.data() as dynamic)['option7val'] ;
      optionval8 = (document.data() as dynamic)['option8val'] ;
      optionval9 = (document.data() as dynamic)['option9val'] ;
      optionval10 = (document.data() as dynamic)['option10val'] ;

      List childrencount = [];

      for (int i=0; i<10; i++) {
        if (choice[i] != '') {
          childrencount.add('option[$i]');
        }
      }
      
      Map usersWhoVoted = (document.data() as dynamic)['resultset'];
      
      //print (usersWhoVoted);
      
if (usersWhoVoted.containsValue(currUser)) {
        return 
    Polls.viewPolls(
      children: [
          Polls.options(title: choice1, value: optionval1),
          Polls.options(title: choice2, value: optionval2),
          if (childrencount.length>2) Polls.options(title: choice3, value: optionval3),
          if (childrencount.length>3) Polls.options(title: choice4, value: optionval4),
          if (childrencount.length>4) Polls.options(title: choice5, value: optionval5),
          if (childrencount.length>5) Polls.options(title: choice6, value: optionval6),
          if (childrencount.length>6) Polls.options(title: choice7, value: optionval7),
          if (childrencount.length>7) Polls.options(title: choice8, value: optionval8),
          if (childrencount.length>8) Polls.options(title: choice9, value: optionval9),
          if (childrencount.length>9) Polls.options(title: choice10, value: optionval10),
          
        ],  
      question:Text('${(document.data() as dynamic)['pollTitle']}', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18.0, color: HexColor('#2D7A98')),),
      userChoice: usersWhoVoted[currUser],
      backgroundColor : Colors.blue,
      leadingBackgroundColor : Colors.blueAccent,
      onVoteBackgroundColor : Colors.blueGrey,
      );
    } else return 
    Polls(                      
        currentUser: currUser, 
        creatorID: (document.data() as dynamic)['creatoruname'], 
        question: Text('${(document.data() as dynamic)['pollTitle']}', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18.0, color: HexColor('#2D7A98')),),
        voteData: usersWhoVoted,
        userChoice: usersWhoVoted[currUser],
        onVoteBackgroundColor: Colors.blue,
        leadingBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        children: [
          Polls.options(title: choice1, value: optionval1),
          Polls.options(title: choice2, value: optionval2),
          if (childrencount.length>2) Polls.options(title: choice3, value: optionval3),
          if (childrencount.length>3) Polls.options(title: choice4, value: optionval4),
          if (childrencount.length>4) Polls.options(title: choice5, value: optionval5),
          if (childrencount.length>5) Polls.options(title: choice6, value: optionval6),
          if (childrencount.length>6) Polls.options(title: choice7, value: optionval7),
          if (childrencount.length>7) Polls.options(title: choice8, value: optionval8),
          if (childrencount.length>8) Polls.options(title: choice9, value: optionval9),
          if (childrencount.length>9) Polls.options(title: choice10, value: optionval10),
          
        ],  

        onVote: (choice) async {
          //print(choice);
          setState(() {
            usersWhoVoted[currUser] = choice;
          });
          FirebaseFirestore.instance.collection('polls').doc(document.id).update({
            'resultset': usersWhoVoted,
            'votes': FieldValue.increment(1),
            'lastModifiedDate': DateTime.now(),
          });
          if (choice == 1) {
            setState(() {
              optionval1 += 1.0;
              saveanswer('option1val', optionval1, currUser, 1, document.id);
            });
          }
          if (choice == 2) {
            setState(() {
              optionval2 += 1.0;
              saveanswer('option2val', optionval2, currUser, 2, document.id);
            });
          }
          if (choice == 3) {
            setState(() {
              optionval3+= 1.0;
              saveanswer('option3val', optionval3, currUser, 3, document.id);
            });
          }
          if (choice == 4) {
            setState(() {
              optionval4+= 1.0;
              saveanswer('option4val', optionval4, currUser, 4, document.id);
            });
          }
          if (choice == 5) {
            setState(() {
              optionval5 += 1.0;
              saveanswer('option5val', optionval5, currUser, 5, document.id);
            });
          }
          if (choice == 6) {
            setState(() {
              optionval6 += 1.0;
              saveanswer('option6val', optionval6, currUser, 6, document.id);
            });
          }
          if (choice == 7) {
            setState(() {
              optionval7 += 1.0;
              saveanswer('option7val', optionval7, currUser, 7, document.id);
            });
          }
          if (choice == 8) {
            setState(() {
              optionval8 += 1.0;
              saveanswer('option8val', optionval8, currUser, 8, document.id);
            });
          }
          if (choice == 9) {
            setState(() {
              optionval9 += 1.0;
              saveanswer('option9val', optionval9, currUser, 9, document.id);
            });
          }
          if (choice == 10) {
            setState(() {
              optionval10 += 1.0;
              saveanswer('option10val', optionval10, currUser, 10, document.id);
            });
          }
        },
    );

      

  // /// This creates view for the creator of the polls
  // Polls.creator(
  //     {required this.children,
  //     required this.question,
  //     this.leadingPollStyle,
  //     this.pollStyle,
  //     this.backgroundColor = Colors.blue,
  //     this.leadingBackgroundColor = Colors.blueAccent,
  //     this.onVoteBackgroundColor = Colors.blueGrey,
  //     this.allowCreatorVote = false})
  //     : viewType = PollsType.creator,
  //       onVote = null,
  //       userChoice = null,
  //       highest = null,
  //       getHighest = null,
  //       voteData = null,
  //       currentUser = null,
  //       creatorID = null,
  //       getTotal = null,
  //       iconColor = null,
  //       outlineColor = Colors.transparent,
  //       assert(children != null),
  //       assert(question != null);

  // /// this creates view for users to cast votes
  // Polls.castVote({
  //   required this.children,
  //   required this.question,
  //   required this.onVote,
  //   this.allowCreatorVote = false,
  //   this.outlineColor = Colors.blue,
  //   this.backgroundColor = Colors.blueGrey,
  //   this.pollStyle,
  // })  : viewType = PollsType.voter,
  //       userChoice = null,
  //       highest = null,
  //       getHighest = null,
  //       getTotal = null,
  //       iconColor = null,
  //       voteData = null,
  //       currentUser = null,
  //       creatorID = null,
  //       leadingBackgroundColor = null,
  //       leadingPollStyle = null,
  //       onVoteBackgroundColor = null,
  //       assert(onVote != null),
  //       assert(question != null),
  //       assert(children != null);
  }
  saveanswer(ans, newval, user, ansnum, id) async {
      await FirebaseFirestore.instance.collection('polls').doc(id).update({
        ans : newval,
      });
      await FirebaseFirestore.instance.collection('polls').doc(id).collection('results').add({
        'user': user,
        'choice': ansnum
      });
    }

  displaySnackBarWithOK(text, action, blockedUsers, pollcreator) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          onPressed: () async {
            blockedUsers.add(pollcreator); 
            await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
              'blockedUsers' : blockedUsers,
            });
            if (action == 'report'){
              displaySnackBarNoButtons('Thank you for reporting. We will review and take appropriate action');
            } else {displaySnackBarNoButtons('You will not see polls from this user.');}
          },
          label: 'YES',
        )
      ));
  }

  displaySnackBarNoButtons(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 3),
      ));
  }
}

Color getlikecolor(bool likeenabled) {
  if (likeenabled == true) {
    return HexColor('#2D7A98');
  } else return Colors.black45;
}

Color getdislikecolor(bool dislikeenabled) {
  if (dislikeenabled == true) {
    return HexColor('#2D7A98');
  } else return Colors.black45;
}

class PollContent{
 String pollID, pollTitle, choice1, choice2, choice3, choice4, choice5, choice6, choice7, choice8, choice9, choice10;
 int pollDur;
 DateTime pollEndDt, pollStDt;

 PollContent({required this.pollID, required this.pollTitle, required this.pollDur, required this.choice1, required this.choice2, 
 required this.choice3, required this.choice4, required this.choice5, required this.choice6, required this.choice7, required this.choice8, 
 required this.choice9, required this.choice10, required this.pollEndDt, required this.pollStDt});
                                
}