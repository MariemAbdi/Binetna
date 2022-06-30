import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate{
  late String code;
  late String person;
  late DateTime start;
  late DateTime end;
  late DateTime sent;
  late String reason;
  late String approved;
  late String refusal_reason;
  late String OtherReason;

  Certificate({required this.code, required this.person, required this.start,
    required this.end, required this.sent, required this.reason, required this.approved, this.refusal_reason="",this.OtherReason=""});

  static Certificate fromJson(Map<String,dynamic> json){
    return Certificate(code: json['code'],
        person: json['person'],
        start: (json['start']as Timestamp).toDate(),
        end: (json['end']as Timestamp).toDate(),
        sent: (json['sent']as Timestamp).toDate(),
        reason: json['reason'],
        approved: json['approved'],
        refusal_reason: json['refusal_reason'],
        OtherReason: json['OtherReason'],

    );}
}

//GET A LIST OF ALL THE CERTIFICATES : HR
Stream<List<Certificate>> readCertifs(String cdt)=> //.orderBy('sent', descending: true)
FirebaseFirestore.instance.collection('certificates').where("approved", isEqualTo: cdt).orderBy('sent', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
    Certificate.fromJson(doc.data())).toList());


//GET A LIST OF ALL THE CERTIFICATES : USER
Stream<List<Certificate>> readMyCertifs(String id)=> //where("person", isEqualTo: id).
FirebaseFirestore.instance.collection('certificates').where("person", isEqualTo: id).orderBy('sent', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
    Certificate.fromJson(doc.data())).toList());