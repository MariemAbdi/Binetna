import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/Services/MyThemes.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/translations/locale_keys.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart' as intl;

import '../Profile/User.dart';
import '../Services/My_Services.dart';
import '../Users Admin/ViewUserInfo.dart';
import 'SingleMessage.dart';

class ChatScreen extends StatefulWidget {

  late String receiverid;
  late String receivername;
  late Widget receiverimage;

  ChatScreen({required this.receiverid, required this.receivername, required this.receiverimage,});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final currentUser=GetStorage();
  TextEditingController _controller = TextEditingController();

  late String email="";
  late String first="";
  late String last="";
  late String phone="";
  late String gender="";
  late String address="";
  late String department="";
  late DateTime dateTime=DateTime.now();

  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('code',isEqualTo: widget.receiverid).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            email=element['mail'];
            first=element["firstName"];
            last=element["lastName"];
            dateTime=(element["birthdate"]as Timestamp).toDate();
            phone=element['phone'];

            gender=element["gender"];
            address=element["address"];
            department=element['department'];

          });
        }));
  }

  //SEND MESSAGE
  SendMessage() async{
    String message=_controller.text;
    _controller.clear();
    await FirebaseFirestore.instance.collection('users').doc(currentUser.read('code'))
        .collection('messages').doc(widget.receiverid).collection('chats').add({
      "senderId":currentUser.read('code'),
      "receiverId":widget.receiverid,
      "message":message,
      "type":"text",
      "date":DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('users').doc(currentUser.read('code')).collection('messages').doc(widget.receiverid).set(
          {'last_message':message,
          'last_date': DateTime.now(),});
    });

    await FirebaseFirestore.instance.collection('users').doc(widget.receiverid)
        .collection('messages').doc(currentUser.read('code')).collection('chats').add({
      "senderId":currentUser.read('code'),
      "receiverId":widget.receiverid,
      "message":message,
      "type":"text",
      "date":DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('users').doc(widget.receiverid).collection('messages').doc(currentUser.read('code')).set(
          {'last_message':message,'last_date': DateTime.now(),});
    });
  }

  //PICKED IMAGE
  XFile? _image;


  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{
        _fetchData();
      },
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: GestureDetector(
              onTap: (){
                //VIEW ACCOUNT'S INFORMATION
                Get.to(ViewUserInfo(code: widget.receiverid, image: widget.receiverimage, email: email, first: first, last: last, Gender: gender, phone: phone, Department: department, address: address, dateTime: dateTime));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 45,height: 45,
                      child: widget.receiverimage,),
                  SizedBox(width: 5,),
                  Text(widget.receivername, style: TextStyle(fontSize: 16),)
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              //chat body
              Expanded(
                child: Container(
                  decoration: ForgotPasswordImage(Theme.of(context)),
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').doc(mydata.read('code')).collection('messages').doc(widget.receiverid).collection('chats').orderBy('date', descending: true).snapshots(),
                    builder: (context,AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                       return ListView.builder(
                           itemCount: snapshot.data.docs.length,
                           reverse: true,
                           physics: BouncingScrollPhysics(),
                           itemBuilder: (context,index){
                             bool isMe=snapshot.data.docs[index]['senderId'].compareTo(mydata.read('code'))==0;
                             return GestureDetector(
                               onTap: (){
                                 if(snapshot.data.docs[index]['type'].compareTo("image")==0){
                                   Get.to(GestureDetector(
                                     onTap: (){
                                       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
                                     },
                                     child: Scaffold(
                                       extendBodyBehindAppBar: true,
                                       appBar: AppBar(
                                         backgroundColor: Colors.transparent,
                                         actions: [
                                           IconButton(
                                             icon: Icon(Icons.download, color: Colors.grey,),
                                             onPressed: () async{
                                               var status= await Permission.storage.request();
                                               if(status.isGranted){
                                                 try{
                                                   var response = await Dio().get(snapshot.data.docs[index]['message'],
                                                       options: Options(responseType: ResponseType.bytes));
                                                   await ImageGallerySaver.saveImage(
                                                       Uint8List.fromList(response.data), quality: 60,);
                                                   ScaffoldMessenger.of(context)
                                                       .showSnackBar(SnackBar(
                                                       content:
                                                       Text(LocaleKeys.imagedownloaded.tr())))
                                                       .closed
                                                       .then((value) => ScaffoldMessenger.of(context)
                                                       .clearSnackBars());

                                                 }catch(e){
                                                   print("The Problem Is: ${e.toString()}");
                                                 }
                                               }
                                             },
                                           )
                                         ],
                                       ),
                                       body: Container(
                                         color: Colors.black,
                                         width: double.infinity,
                                         height: double.infinity,
                                         child: Center(
                                           child: Container(
                                             height: double.infinity,
                                             child: FullScreenWidget(
                                               child: InteractiveViewer(
                                                   panEnabled: true,
                                                   scaleEnabled: true,
                                                   child: FittedBox(
                                                     fit: BoxFit.fitWidth,
                                                     child: Image.network(snapshot.data.docs[index]['message'],),
                                                   )),),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ));
                                 }
                               },
                                 child: SingleMessage(isMe: isMe,message: snapshot.data.docs[index]['message'],receiverid: widget.receiverid,type: snapshot.data.docs[index]['type'],sent: intl.DateFormat("dd/MM/yyyy\nkk:mm").format(snapshot.data.docs[index]['date'].toDate()),));
                           });
                      }
                      return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);
                    },
                  ),
                ),
              ),
              //MESSAEG FIELD
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      style: TextStyle(color: Colors.black),
                      inputFormatters: [UpperCaseTextFormatter()],
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: LocaleKeys.typemsg.tr(),
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.grey[100],
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: (){
                              getImage();
                            },
                            icon: Icon(Icons.photo,color: Colors.grey,),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0,color:MyThemes.darkgreen),
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(25),

                          )
                      ),
                    )),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){SendMessage();},
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle,color: MyThemes.darkgreen),
                        child: Icon(Icons.send,color: Colors.white,),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //UPLOAD SELECTED IMAGE TO FIREBASE STORAGE
  Future uploadImage() async{
    String fileName=Uuid().v1();
    final file = File(_image!.path);
    var ref=FirebaseStorage.instance.ref().child('chatImage').child("$fileName.jpg");
    var uploadTask = await ref.putFile(file);

    String ImageUrl= await uploadTask.ref.getDownloadURL();

    _controller.clear();
    await FirebaseFirestore.instance.collection('users').doc(currentUser.read('code'))
        .collection('messages').doc(widget.receiverid).collection('chats').add({
      "senderId":currentUser.read('code'),
      "receiverId":widget.receiverid,
      "message":ImageUrl,
      "type":"image",
      "date":DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('users').doc(currentUser.read('code')).collection('messages').doc(widget.receiverid).set(
          {'last_message':ImageUrl,'last_date': DateTime.now(),});
    });

    await FirebaseFirestore.instance.collection('users').doc(widget.receiverid)
        .collection('messages').doc(currentUser.read('code')).collection('chats').add({
      "senderId":currentUser.read('code'),
      "receiverId":widget.receiverid,
      "message":ImageUrl,
      "type":"image",
      "date":DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('users').doc(widget.receiverid).collection('messages').doc(currentUser.read('code')).set(
          {'last_message':ImageUrl,'last_date': DateTime.now(),});
    });

    print(ImageUrl);
  }


  //OPENING FOLDER / CAMERA
  Future<void> getImage() async {
    try {
      XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _image = imageFile;
          //SAVE THE PICTURE TO THE FIREBASE STORAGE
          uploadImage();
        });
      }} on PlatformException catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString()))).closed
          .then((value) =>
          ScaffoldMessenger.of(context).clearSnackBars());
    }
  }

}
