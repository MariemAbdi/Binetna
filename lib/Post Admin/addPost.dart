import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/Services/Validators.dart';

import '../Appbar/Header.dart';
import '../Services/My_Services.dart';
import '../Services/Notifications.dart';
import '../translations/locale_keys.g.dart';

class addPost extends StatefulWidget {
  const addPost({Key? key}) : super(key: key);

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {

  //THE FORM KEY
  final _formKey = GlobalKey<FormState>();

  //LIST OF CONTROLLERS
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  //FORM FIELDS
  late String TitleField;
  late String DescriptionField;

  //CATEGORY DROPDOWN
  int position = 0;
  static List<String> categ=[];
  static List<String> categEN = [
    "Category",
    "Event",
    "Celebration",
    "News",
    "Other",
  ];
  static List<String> categFR = [
    "Catégorie",
    "Événement",
    "Fête",
    "Nouvelles",
    "Autre",
  ];

  //PICKED IMAGE
  XFile? _image;


  String? thistoken = " ";
  void getToken() async{
  await FirebaseMessaging.instance.getToken().then((token) {
    setState(() {
      thistoken=token;
    });
  });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    loadFCM();
    listenFCM();
    getToken();
  }

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?categ=List.from(categEN):categ=List.from(categFR);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    TitleController.dispose();
    DescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS

    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersiveSticky, overlays: []);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: LocaleKeys.AddPost.tr(),
        ),
        body: SafeArea(
          child: Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BackgroundImage(Theme.of(context)),
              child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          SizedBox(
                            height: 20,
                          ),
                          //TITLE FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                controller: TitleController,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.title),
                                  hintText: LocaleKeys.Title.tr(),
                                  border: InputBorder.none,
                                  suffixIcon: TitleController.text.isEmpty
                                      ? null
                                      : IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      TitleController.clear();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSaved: (val) => setState(() {
                                  TitleField = val!;
                                }),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //Description FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                controller: DescriptionController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  hintText: LocaleKeys.Description.tr(),
                                  border: InputBorder.none,
                                  suffixIcon: DescriptionController.text.isEmpty
                                      ? null
                                      : IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      DescriptionController.clear();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSaved: (val) => setState(() {
                                  DescriptionField = val!;
                                }),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          //CATEGORY
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.category),
                                hintText: categ[position], //gender[position],
                                hintStyle: TextStyle(color: position==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTap: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => SizedBox(
                                      height: 180,
                                      child: CupertinoPicker(
                                        scrollController:
                                        FixedExtentScrollController(
                                            initialItem: position),
                                        backgroundColor: Colors.white,
                                        itemExtent: 50,
                                        onSelectedItemChanged: (index) {
                                          setState(() {
                                            //position=findGender(gender, hintGender);
                                            this.position = index;
                                          });
                                        },
                                        looping: true,
                                        children: [
                                          for (String name in categ) Text(name),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          GestureDetector(onTap: () {_SelectImageDialog();},
                              child: Container(
                                height: size.width * 0.8,
                                width: size.width *0.8,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: _image==null
                                    ?Center(child: FittedBox(fit: BoxFit.fitWidth,child: Text(LocaleKeys.clicktoupload.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20),)))
                                    :Image(image: FileImage(File(_image!.path)),fit: BoxFit.cover,),
                              )),

                          SizedBox(
                            height: 10,
                          ),

                          InkWell(
                            onTap: () async {

                              FocusScope.of(context).unfocus();

                              _formKey.currentState!.save();

                              bool tests = false;

                              //FILED VALIDATION
                              tests=Post_Add_Edit_Validator(context,TitleField,DescriptionField,categ[position],_image);

                              /*tests=isEmptyValidation(context, TitleField, 'emptytitle'.tr);
                              tests=isEmptyValidation(context, DescriptionField, "emptydescription");
                              tests=dropDownVerification(categ[position], "Category".tr, "emptycategory".tr, context);*/

                              if(!tests)
                              {
                                //ADD POST
                               FirebaseFirestore.instance.collection('posts').add(
                                   {"title": TitleField,
                                   "description": DescriptionField,
                                   "category": categEN[position],
                                   "likes":[],
                                   "creation_date": DateTime.now(),
                                   "lastupdate": DateTime.now(),
                                   "id":""},).then((value) {
                                    uploadImage(value.id);

                                 final docUser = FirebaseFirestore.instance.collection('posts').doc(value.id);
                                 //UPDATE THE FIELDS
                                 docUser.update({
                                   'id': value.id,
                                 });

                                 setState(() {_image=null;});
                               });

                               AddedSuccessfullyAlert(context,"Post");

                               //send notification to users
                               sendPushMessage(TitleField, DescriptionField, "notifications");


                               TitleController.clear();
                               DescriptionController.clear();
                               position=0;







                              }


                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: ButtonColor(Theme.of(context)),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              child: Text(
                                LocaleKeys.SAVE.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

//DIALOG TO SELECT IMAGE FROM GALLERY OR CAMERA
  void _SelectImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(LocaleKeys.AddPhoto.tr()),
          actions: [
            // TAKE A PHOTO : CAMERA
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.camera);
              },
              child: Text(LocaleKeys.TakePhoto.tr(),style: TextStyle(color: Colors.black),),
            ),

            // CHOOSE A PHOTO : GALLERY
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.gallery);
              },
              child: Text(LocaleKeys.ChoosePhoto.tr(),style: TextStyle(color: Colors.black)),
            ),
          ],

          // CANCEL
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              LocaleKeys.Cancel.tr(),
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  Future uploadImage(String id) async{
    final file = File(_image!.path);
    final path = 'post pics/${id+".jpg"}';

    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }


  //OPENING FOLDER / CAMERA
  void _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    try {
      XFile? imageFile = await ImagePicker().pickImage(source: source);
      if (imageFile != null) {
        setState(() {
          _image = imageFile;
        });

      }} on PlatformException catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString()))).closed
          .then((value) =>
          ScaffoldMessenger.of(context).clearSnackBars());
    }
  }
}
