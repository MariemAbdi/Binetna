import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class User{
  late String code;
  late String firstName;
  late String lastName;
  late String phone;
  late String mail;
  late String department;
  late String password;
  late DateTime birthdate;
  late String address;
  late String gender;
  late bool activated;

  User({this.code="",required this.firstName,required this.lastName,
    required this.phone,required this.mail, required this.department,
    required this.password,required this.birthdate, required this.address,
    required this.gender,required this.activated});

  Map<String,dynamic> toJson()=>{
    'code': code,
    'firstName': firstName,
    'lastName': lastName,
    'mail': mail,
    'password': password,
    'department': department,
    'phone': phone,
    'birthdate': birthdate,
    'address': address,
    'gender': gender,
    'activated': activated,
  };

  static User fromJson(Map<String,dynamic> json){
    return User(code: json['code'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mail: json['mail'],
      password: json['password'],
      department: json['department'],
      phone: json['phone'],
      birthdate: (json['birthdate']as Timestamp).toDate(),
      address: json['address'],
      gender: json['gender'],
      activated: json['activated'],);}
}

Future createUser({required String code,required String firstName,required String lastName, required String phone,required String mail, required String department,String password="",required DateTime birthdate, required String address, required String gender, required String image_path, required bool activated}) async{

  //REFERENCE TO A DOCUMENT
  final docUser= FirebaseFirestore.instance.collection('users').doc('$code');

  final user = User(code: code, firstName: firstName, lastName: lastName, phone: phone, mail: mail, department: department, password: password, birthdate: birthdate, address: address, gender: gender, activated: activated);

  final json = user.toJson();

  //CREATE DOCUMENT AND WRITE DATA TO FIREBASE
  await docUser.set(json);
}

  //GET A LIST OF ALL THE DOCUMENTS IN THE COLLECTION
  Stream<List<User>> readUsers(bool cdt)=>
  FirebaseFirestore.instance.collection('users').where("activated",isEqualTo: cdt).orderBy('firstName', descending: false).snapshots().map((event) => event.docs.map((doc) =>
  User.fromJson(doc.data())).toList());


final mydata=GetStorage();

void HasRole(String code){
  //IF CERTIFS ADMIN
  FirebaseFirestore.instance.collection('users').doc('Certif Admin').get().then((DocumentSnapshot snapshot) {
    if(code.compareTo(snapshot['code'])==0){
      mydata.write("role", "certifs");
    }
  });
  //IF POSTS ADMIN
  FirebaseFirestore.instance.collection('users').doc('Post Admin').get().then((DocumentSnapshot snapshot) {
    if(code.compareTo(snapshot['code'])==0){
      mydata.write("role", "posts");
    }
  });

  //IF USER ADMIN
  FirebaseFirestore.instance.collection('users').doc('User Admin').get().then((DocumentSnapshot snapshot) {
    if(code.compareTo(snapshot['code'])==0){
      mydata.write("role", "users");
    }
  });
}


// CURRENT USER
Stream<QuerySnapshot<Map<String, dynamic>>> GetUser(String receiver){
 return FirebaseFirestore.instance.collection('users').doc(mydata.read('code')).collection('messages').doc(receiver).collection('chats').orderBy('date', descending: true).snapshots();
}

