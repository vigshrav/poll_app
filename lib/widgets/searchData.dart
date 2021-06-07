import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, String>> searchRes = [];

genList (query) async {
  await FirebaseFirestore.instance.collection('users').orderBy('usrname').startAt([query]).endAt([query + '\uf8ff']).get().then((querySnapshot) => {
    if (querySnapshot.docs.isNotEmpty){
      searchRes.clear(),
    querySnapshot.docs.forEach((doc) => {
      
      searchRes.add({'name':doc.data()['usrname'], 'id': doc.id}),

    })
    } else print ('Search result empty!')
  });
  //print (searchRes);
  return searchRes;
}


class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 0));
    //print(await genList(query));
      return await genList(query);
    // return List.generate(3, (index) {
    //   return {
    //     'name': genList(query)
        //'price': Random().nextInt(100).toString()
    //   };
    // });
  }
}

class CitiesService {
  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}