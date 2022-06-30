import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/Services/storage_service.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Appbar/Header.dart';
import '../HomePage/Home.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/Validators.dart';
import '../SideBar/SideBar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  //SHARED PREFRENCES
  final userdata=GetStorage();

  //THE FORM KEY
  final _formKey = GlobalKey<FormState>();

  //PASSWORD'S VISIBILITY
  bool _isVisible = false;

  //LIST OF CONTROLLERS
  final MailController = TextEditingController();
  final CodeController = TextEditingController();
  final PassController = TextEditingController();
  final FirstController = TextEditingController();
  final LastController = TextEditingController();
  final PhoneController = TextEditingController();

  final _controller= TextEditingController();


  //FOCUS NODE
  final PassFocus = FocusNode();

  //BIRTHDATE INITIAL VALUE
  DateTime dateTime = DateTime.now();

  //FIELDS
  late String RegCode;
  late String RegMail;
  late String RegFirst;
  late String RegLast;
  late String RegPhone;
  late String RegPass;
  late int profile=0;

  String password="";

  //HINT TEXTS
  late String hintCode="";
  late String hintPass="";
  late String img_path="";

  //PICKED IMAGE
  XFile? _image;

  //ADDRESS DROPDOWN
  static List<String> stat=[];
  int index=0;
  static List<String> statFR = [
    "Adresse",
    "Ariana",
    "Beja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Kef",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];
  static List<String> statEN = [
    "Address",
    "Ariana",
    "Beja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Kef",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];



  //DEPARTMENT DROPDOWN
  static List<String> dept=[];
  int pos=0;
  static List<String> deptEN = [
    "Department",
    "Accounting & Finance",
    "Customer Service",
    "Distribution",
    "Human Resources",
    "Information Technology",
    "Marketing",
    "Sales",
    "Search & Development",
  ];
  static List<String> deptFR = [
    "Département",
    "Commercial",
    "Comptabilité & Finance",
    "Distribution",
    "Informatique",
    "Recherche & Développement",
    "Ressources Humaines",
    "Service Client",
    "Vente",
  ];


  //GENDER DROPDOWN
  static List<String> gender=[];
  int position=0;
  static List<String> genderEN = [
    "Gender",
    "Female",
    "Male",];
  static List<String> genderFR = [
    "Sexe",
    "Féminin",
    "Masculin",];


  initialisations() {
    context.locale == Locale('en')?stat.addAll(statEN):stat.addAll(statFR);
    context.locale == Locale('en')?dept=List.from(deptEN):dept=List.from(deptFR);
    context.locale == Locale('en')?gender=List.from(genderEN):gender=List.from(genderFR);
  }

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    initialisations();
    super.didChangeDependencies();
  }

  @override
  void dispose(){
     MailController.dispose();
     CodeController.dispose();
     PassController.dispose();
     FirstController.dispose();
     LastController.dispose();
     PhoneController.dispose();
    super.dispose();
  }

  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }

  void _fetchData() async{
   FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: userdata.read('mail')).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            hintCode=element['code'];
            MailController.text=userdata.read('mail');
            FirstController.text=element["firstName"];
            LastController.text=element["lastName"];
            dateTime=(element["birthdate"]as Timestamp).toDate();
            PhoneController.text=element['phone'];
            hintPass=element['password'];

            profile=findIndex(genderEN, element["gender"]);

            img_path=element['code'];
            position=findIndex(genderEN, element["gender"]);
            index=findIndex(statEN,element["address"]);
            pos=findIndex(deptEN, element['department']);

          });
        }));
  }

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(){
    return FutureBuilder(
      future:storage.downloadURL("profile pictures",img_path+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(!snapshot.hasData){
          return CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NoImage(genderEN[profile]),);
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return ClipOval(
            child: Image.network(snapshot.data!, fit: BoxFit.cover,),
          );
        }
        if(snapshot.connectionState==ConnectionState.waiting || !snapshot.hasData){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{
        _fetchData();
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details){
          if(details.delta.direction <=0){
            Get.to(HomePage());
          }
        },
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: MyAppBar(
            title: LocaleKeys.MyProfile.tr(),
          ),
          drawer: MySideBar(),
          body: SafeArea(
            child: Expanded(
              child: Container(
                width: double.infinity,
                decoration: BackgroundImage(Theme.of(context)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            // PROFILE PICTURE
                            Stack(
                              children: [Container(
                                width: size.width / 3,
                                height: size.width / 3,

                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.grey),
                                  shape: BoxShape.circle,
                                ),


                                child: _image==null? retrieveImage()
                                :ClipOval(child: Image(image: FileImage(File(_image!.path)),fit: BoxFit.cover,)),

                                //CircleAvatar(


                              ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _SelectImageDialog();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                          color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ],
                            ),

                            //SOME SPACING
                            SizedBox(
                              height: 10,
                            ),


                            //REGISTRATION CODE FIELD
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                enabled: false,
                                controller: CodeController,
                                decoration: InputDecoration(
                                  icon: Icon(CupertinoIcons.number),
                                  hintText: hintCode,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                                onSaved: (val) => setState(() {
                                  RegCode = val!;
                                }),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),

                            //SOME SPACING
                            SizedBox(
                              height: 10,
                            ),

                            //E-MAIL FIELD GOES HERE
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  keyboardType: TextInputType.emailAddress,
                                  maxLines: null,
                                  autofillHints: [AutofillHints.email],
                                  controller: MailController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  onSaved: (val) => setState(() {
                                    RegMail = val!.trim().toLowerCase();
                                  }),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.alternate_email),
                                    hintText: LocaleKeys.email.tr(),
                                    suffixIcon: MailController.text.isEmpty
                                        ? null
                                        : IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        MailController.clear();
                                        FocusScope.of(context).unfocus();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //FIRST NAME FIELD
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: TextFormField(
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  controller: FirstController,
                                  keyboardType: TextInputType.name,
                                  maxLines: null,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.face),
                                    hintText: LocaleKeys.FirstName.tr(),
                                    border: InputBorder.none,
                                    suffixIcon: FirstController.text.isEmpty
                                        ? null
                                        : IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        FirstController.clear();
                                        FocusScope.of(context).unfocus();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  onSaved: (val) => setState(() {
                                    RegFirst = val!;
                                  }),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //LAST NAME FIELD
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: TextFormField(
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  controller: LastController,
                                  keyboardType: TextInputType.name,
                                  maxLines: null,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.sort_by_alpha_rounded),
                                    hintText: LocaleKeys.LastName.tr(),
                                    border: InputBorder.none,
                                    suffixIcon: LastController.text.isEmpty
                                        ? null
                                        : IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        LastController.clear();
                                        FocusScope.of(context).unfocus();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  onSaved: (val) => setState(() {
                                    RegLast = val!;
                                  }),
                                ),
                              ),
                            ),

                            //SOME SPACE
                            SizedBox(
                              height: 10,
                            ), //SOME SP

                            //GENDER
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.female),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: gender[position],
                                  hintStyle: TextStyle(color: position==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,),
                                onChanged: (value) {
                                  setState(() {
                                  });},

                                onTap: (){
                                  showCupertinoModalPopup(context: context,
                                      builder: (context)=>SizedBox(
                                        height: 180,
                                        child: CupertinoPicker(
                                          scrollController: FixedExtentScrollController(initialItem: position),
                                          backgroundColor: Colors.white,
                                          itemExtent: 50,
                                          onSelectedItemChanged: (index){setState(() {
                                            this.position=index;
                                          });},
                                          looping: true,
                                          children: [
                                            for (String name in gender) Text( name ),
                                          ],
                                        ),

                                      ));},),),


                            SizedBox(
                              height: 10,
                            ),

                            //ADDRESS
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,),
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.map_outlined),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: stat[index],
                                  hintStyle: TextStyle(color: index==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,),
                                onChanged: (value) {
                                  setState(() {
                                  });},

                                onTap: (){
                                  showCupertinoModalPopup(context: context,
                                      builder: (context)=>SizedBox(
                                        height: 180,
                                        child: CupertinoPicker(
                                          scrollController: FixedExtentScrollController(initialItem: index),
                                          backgroundColor: Colors.white,
                                          itemExtent: 50,
                                          onSelectedItemChanged: (index){setState(() {
                                            this.index=index;
                                          });},

                                          looping: true,
                                          children: [
                                            for (String name in stat) Text( name ),
                                          ],
                                        ),
                                      ));},),),

                            SizedBox(
                              height: 10,
                            ),

                            //BIRTHDATE
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,),

                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: DateFormat('dd/MM/yyyy').format(dateTime),
                                  hintStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onTap: (){showCupertinoModalPopup(context: context,
                                    builder: (context)=>CupertinoActionSheet(
                                      actions: [
                                        SizedBox(height: 180,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date, initialDateTime: dateTime,
                                            maximumYear: DateTime.now().year,
                                            minimumYear: 1900,
                                            onDateTimeChanged: (dateTime){
                                              setState(() {
                                                this.dateTime=dateTime;
                                              });

                                            },
                                          ),),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                          child: Text(LocaleKeys.DONE.tr()),
                                          onPressed: (){Navigator.pop(context);}
                                      ),
                                    )
                                );
                                },),),

                            SizedBox(height: 10,),//SOME SPACING

                            //PHONE NUMBER FIELD
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                controller: PhoneController,
                                keyboardType: TextInputType.phone,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone_android_rounded),
                                  hintText: LocaleKeys.PhoneNumber.tr(),
                                  border: InputBorder.none,
                                  suffixIcon: PhoneController.text.isEmpty
                                      ? null
                                      : IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      PhoneController.clear();
                                      FocusScope.of(context).unfocus();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSaved: (val) => setState(() {
                                  RegPhone = val!;
                                }),
                              ),
                            ),

                            //SOME SPACING
                            SizedBox(
                              height: 10,
                            ),

                            //DEPARTMENT LIST
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,),
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.work),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: dept[pos],
                                  hintStyle: TextStyle(color: pos==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,),
                                onChanged: (value) {
                                  setState(() {
                                  });},

                                onTap: (){
                                  showCupertinoModalPopup(context: context,
                                      builder: (context)=>SizedBox(
                                        height: 180,
                                        child: CupertinoPicker(
                                          scrollController: FixedExtentScrollController(initialItem: pos),
                                          backgroundColor: Colors.white,
                                          itemExtent: 50,
                                          onSelectedItemChanged: (index){setState(() {
                                            this.pos=index;
                                          });},
                                          looping: true,
                                          children: [
                                            for (String name in dept) Text( name ),
                                          ],
                                        ),
                                      ));},),),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //PASSWORD FIELD GOES HERE
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                controller: PassController,
                                focusNode: PassFocus,
                                obscureText: !_isVisible,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    icon: _isVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  ),
                                  hintText: LocaleKeys.pass_word.tr(),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSaved: (val) => setState(() {
                                  RegPass = val!;
                                }),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //SAVE BUTTON
                            InkWell(
                              onTap:() async {
                                FocusScope.of(context).unfocus();

                                _formKey.currentState!.save();

                                bool tests = false;

                                //FIELD VALIDATION
                                tests=Profile_Update_Validator(context,RegMail,RegFirst,RegLast,gender[position],stat[index],dateTime,RegPhone,dept[pos],RegPass);

                                if(!tests)
                                {
                                  if(RegMail.compareTo(userdata.read('mail'))!=0 || RegPass.isNotEmpty) {
                                    //CHECK IF MAIL EXISTS ALREADY
                                    final snap=await FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: RegMail).get();
                                     if(snap.docs.length!=0 && RegMail.compareTo(userdata.read('mail'))!=0){
                                        //THIS MAIL IS USED ALERT
                                        ThisMailExistsAlert(context);
                                      }else{
                                       // RETYPE CURRENT PASSWORD
                                       final newpassword= await openDialog();
                                       if(newpassword==null || newpassword.isEmpty){return;}

                                       setState(() {
                                         this.newpassword=newpassword;
                                       });

                                       if(decryptPassword(this.newpassword, hintPass)){

                                         final docUser = FirebaseFirestore.instance
                                             .collection('users')
                                             .doc(hintCode);

                                         //UPDATE THE FIELDS
                                         docUser.update({
                                           'firstName': RegFirst,
                                           'lastName': RegLast,
                                           'mail': RegMail,
                                           'department': deptEN[pos],
                                           'phone': RegPhone,
                                           'birthdate': dateTime,
                                           'address': statEN[index],
                                           'gender': genderEN[position],
                                           'password': encryptPassword(RegPass),
                                         });

                                         //UPDATE DATA IN AUTHENTICATION
                                         final User? currentUser =
                                             FirebaseAuth.instance.currentUser;
                                         if (currentUser != null) {
                                           currentUser.updateEmail(RegMail);
                                           currentUser.updatePassword(RegPass);

                                           //RESET DATA
                                           _fetchData();

                                           UpdateSuccessAlert(context);}




                                       }
                                     }
                                  }else if(RegMail.compareTo(userdata.read('mail'))==0){
                                      final docUser = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(hintCode);

                                      //UPDATE THE FIELDS
                                      docUser.update({
                                        'firstName': RegFirst,
                                        'lastName': RegLast,
                                        'department': deptEN[pos],
                                        'phone': RegPhone,
                                        'birthdate': dateTime,
                                        'address': statEN[index],
                                        'gender': genderEN[position],
                                      });

                                      //RESET DATA
                                      _fetchData();

                                      UpdateSuccessAlert(context);
                                    }

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
                              height: 30,
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              ),
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

            // REMOVE CURRENT PHOTO : DEFAULT
            CupertinoActionSheetAction(
              onPressed: () async {

                Navigator.pop(context);
                setState(() {
                  _image = null;
                });

                //DELETE IMAGE FROM DATA STORAGE
                final ref = FirebaseStorage.instance.ref();
                final variable= ref.child("profile pictures/$hintCode.jpg");
                await variable.delete();


                //REMOVE THE PATH IN DATABASE
                final docUser = FirebaseFirestore.instance.collection('users').doc(hintCode);
                //UPDATE THE FIELDS
                docUser.update({
                  'image_path': ''
                });

                _fetchData();

              },
              child: Text(LocaleKeys.RemoveCurrentPhoto.tr(),style: TextStyle(color: Colors.black)),
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

  //UPLOAD SELECTED IMAGE TO FIREBASE STORAGE
  Future uploadImage() async{
    final file = File(_image!.path);
    //final path = 'profile pictures/${_image!.name}';
    final path = 'profile pictures/${hintCode+".jpg"}';

    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }


  //OPENING FOLDER / CAMERA
  Future<void> _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    try {
      XFile? imageFile = await ImagePicker().pickImage(source: source);
      if (imageFile != null) {
        setState(() {
          _image = imageFile;
        });
        //SAVE THE PICTURE TO THE FIREBASE STORAGE
        uploadImage();

        setState(() {

        });
      }} on PlatformException catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString()))).closed
          .then((value) =>
          ScaffoldMessenger.of(context).clearSnackBars());
    }
  }

  String encryptPassword(String pass){
    String encryptedPassword="";
    for(int i=0; i<pass.length;i++){
      encryptedPassword+=String.fromCharCode(pass.codeUnitAt(i)+pass.length);
    }
    return encryptedPassword;
  }

  bool decryptPassword(String pass, String hashedPass){
    bool encryptedPassword=false;
    String encrypted="";
    for(int i=0; i<hashedPass.length;i++){
      encrypted+=String.fromCharCode(hashedPass.codeUnitAt(i)-hashedPass.length);
    }
    encryptedPassword= pass.compareTo(encrypted)==0;

    return encryptedPassword;
  }

  late TextEditingController alertController=TextEditingController();
  String newpassword='';

  Future<String?> openDialog()=>showDialog<String>(context: context, builder: (context)=> AlertDialog(
    title: Text(LocaleKeys.pass_word.tr()),
    content: TextField(
      autofocus: true,
      controller: alertController,
      obscureText: true,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 3, color: MyThemes.darkgreen),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 3, color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
          borderSide:  BorderSide(width: 3, color: Colors.red),
      borderRadius: BorderRadius.circular(15),
    ),
          prefixIcon: Icon(Icons.lock, color: Colors.black,),
          hintText: LocaleKeys.pass_word.tr(),
          hintStyle: TextStyle(color: Colors.black)
      ),
    ),
    actions: [
      TextButton(onPressed: (){
        if(alertController.text.isEmpty || decryptPassword(alertController.text, hintPass)) {
                      Navigator.of(context).pop(alertController.text);
                      alertController.clear();
                    }
        else if (!decryptPassword(alertController.text, hintPass)){
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
              content:
              Text("wrong pass $hintPass")))
              .closed
              .then((value) => ScaffoldMessenger.of(context)
              .clearSnackBars());
        }
                  }, child: Text(LocaleKeys.DONE, style: TextStyle(color: MyThemes.darkgreen),))
    ],
  ));
}

