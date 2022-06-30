import 'package:cloud_firestore/cloud_firestore.dart';

class CarpoolingModel{

  late String id;
  late String person;
  late DateTime day_time;
  late int places;
  late List<String> people;
  late List<String> accepted;
  late List<String> destinations;
  late String conditions;


  CarpoolingModel({required this.id,required this.person, required this.day_time, required this.places,required this.people,required this.accepted,required this.destinations,required this.conditions});

  static CarpoolingModel fromJson(Map<String,dynamic> json){
    return CarpoolingModel(
      id: json['id'],
      person: json['person'],
      day_time: json['day_time'].toDate(),
      places: json['places'],
      people: json['people'].cast<String>(),
      accepted: json['accepted'].cast<String>(),
      destinations: json['destinations'].cast<String>(),
      conditions: json['conditions'],

    );}

}

Stream<List<CarpoolingModel>> readSpecificOffer(String id)=>
    FirebaseFirestore.instance.collection('carpooling').where('id',isEqualTo: id).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        CarpoolingModel.fromJson(doc.data())).toList());


//GET A LIST OF ALL THE DOCUMENTS IN THE COLLECTION
Stream<List<CarpoolingModel>> readOffers()=>
    FirebaseFirestore.instance.collection('carpooling').orderBy('day_time', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        CarpoolingModel.fromJson(doc.data())).toList());

//JOINED LIST
Stream<List<CarpoolingModel>> readMyOffers(String code)=>
FirebaseFirestore.instance.collection('carpooling').where('people',arrayContains: code).orderBy('day_time', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
CarpoolingModel.fromJson(doc.data())).toList());

//ACCEPTED LIST
Stream<List<CarpoolingModel>> readAcceptedOffers(String code)=>
    FirebaseFirestore.instance.collection('carpooling').where('accepted',arrayContains: code).orderBy('day_time', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        CarpoolingModel.fromJson(doc.data())).toList());


//CREATED OFFERS
Stream<List<CarpoolingModel>> readCreatedOffers(String code)=>
    FirebaseFirestore.instance.collection('carpooling').where('person',isEqualTo: code).orderBy('day_time', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        CarpoolingModel.fromJson(doc.data())).toList());

