import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;

class UserObjs {

  String id;
  String uName;
  String eMail;
  String phone;
  String avatarURL;
  int polls;
  int followers;
  int following;
 

  UserObjs({ required this.id, required this.uName, required this.eMail, required this.phone, required this.avatarURL, required this.polls, required this.followers, required this.following });
}

