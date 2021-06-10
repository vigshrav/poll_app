

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polling_app/models/userObjs.dart';

class UserServices {

  final String uid;
  UserServices({ required this.uid });
  var now = new DateTime.now();

  //*********Get user root data from DB
    Stream<UserObjs> get userRootData {
      return FirebaseFirestore.instance.collection('users').doc(uid).snapshots()
      .map(_expUserObjListFromSnapshot);
    }

  // User root data stream
    UserObjs _expUserObjListFromSnapshot(DocumentSnapshot snapshot) {
    
        return UserObjs(
          
          id: snapshot.id,
          uName: (snapshot.data() as dynamic)['usrname'],
          eMail: (snapshot.data() as dynamic)['email'],
          phone: (snapshot.data() as dynamic)['phno'],
          avatarURL: (snapshot.data() as dynamic)['avatarURL'],
          polls: (snapshot.data() as dynamic)['polls'],
          followers: (snapshot.data() as dynamic)['followers'],
          following: (snapshot.data() as dynamic)['following'],
          blockedUsers: (snapshot.data() as dynamic)['blockedUsers'],
         
        );

    }


}