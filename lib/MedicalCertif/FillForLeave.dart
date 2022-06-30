import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/Appbar/Header.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/Validators.dart';

class FillLeave extends StatefulWidget {
  const FillLeave({Key? key}) : super(key: key);

  @override
  State<FillLeave> createState() => _FillLeaveState();
}

class _FillLeaveState extends State<FillLeave> {

  //THE FORM KEY
  final _formKey = GlobalKey<FormState>();

  final otherReasonController = TextEditingController();

  //PICKED IMAGE
  XFile? _image;

  //SHARED PREFRENCES
  final userdata=GetStorage();

  late String Code="";
  late String First="";
  late String Last="";
  late String Department="";
  late String Phone="";


  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: userdata.read('mail')).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            Code=element['code'];
            First=element['firstName'];
            Last=element['lastName'];
            Department=element['department'];
            Phone=element['phone'];
          });
        }));
  }

  //START INITIAL VALUE
  DateTime starting = DateTime.now();

  //END INITIAL VALUE
  DateTime ending = DateTime.now();


  //REASON DROPDOWN
  static List<String> reasons=[];
  int position = 0;
  static List<String> reasonsEN = [
    "Reason",
    "Common Cold",
    "Covid-19",
    "Hospitalization",
    "Injury",
    "Sore Throat/Flu",
    "Virus",
    "Other",
  ];
  static List<String> reasonsFR = [
    "Cause",
    "Angine/Grippe",
    "Blessure",
    "Covid-19",
    "Hospitalisation",
    "Rhume",
    "Virus",
    "Autre",
  ];


  initialisations(){
    setState(() {
      position=0;
      starting=DateTime.now();
      ending=DateTime.now();
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?reasons=List.from(reasonsEN):reasons=List.from(reasonsFR);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
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
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: MyAppBar(
            title: LocaleKeys.FillLeave.tr(),
          ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(
                              height: 20,
                            ),

                            //CODE FIELD
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: Code,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //FIRST NAME FIELD
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
                                  enabled: false,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.face),
                                    hintText: First,
                                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //LAST NAME FIELD
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
                                  enabled: false,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.face),
                                    hintText: Last,
                                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //DEPARTMENT FIELD
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
                                  enabled: false,
                                  maxLines: null,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.work),
                                    hintText: Department,
                                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //PHONE FIELD
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
                                  enabled: false,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.phone),
                                    hintText: Phone,
                                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING


                            Divider(color: ErrorColor(Theme.of(context)),thickness: 1,height: 10,indent: 50,endIndent: 50,),

                            SizedBox(height: 10,),

                            //REASON
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
                                  icon: Icon(Icons.medical_services),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: reasons[position], //gender[position],
                                  hintStyle: TextStyle(color: position==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height: 180,
                                        child: CupertinoPicker(
                                          scrollController:
                                          FixedExtentScrollController(initialItem: position),
                                          backgroundColor: Colors.white,
                                          itemExtent: 50,
                                          onSelectedItemChanged: (index) {
                                            setState(() {
                                              this.position = index;
                                            });
                                          },
                                          looping: true,
                                          children: [
                                            for (String name in reasons) Text(name),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ),

                            Visibility(
                              visible: position==reasons.length-1? true:false,
                              child: SizedBox(
                              height: 10,
                            ), ),//SOME SPACING

                            //OTHER REASON FIELD
                            Visibility(
                              visible: position==reasons.length-1? true:false,
                              child: Container(
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
                                    keyboardType: TextInputType.text,
                                    maxLines: null,
                                    controller: otherReasonController,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.question_mark),
                                      hintText: LocaleKeys.Reason.tr(),
                                      border: InputBorder.none,
                                      suffixIcon: otherReasonController.text.isEmpty
                                          ? null
                                          : IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          otherReasonController.clear();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10,),//SOME SPACING

                            //START
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor,),

                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: starting.difference(DateTime.now()).inDays==0? LocaleKeys.Starting.tr():DateFormat('dd/MM/yyyy').format(starting),//DateFormat('dd/MM/yyyy').format(hintBD),//dateTime.difference(DateTime.now()).inDays ==0 ? "Birthdate" : DateFormat('dd/MM/yyyy').format(dateTime),//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                                  hintStyle: TextStyle(color: starting.difference(DateTime.now()).inDays==0? Colors.grey.shade300 :Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onTap: (){showCupertinoModalPopup(context: context,
                                    builder: (context)=>CupertinoActionSheet(
                                      actions: [
                                        SizedBox(height: 180,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date, initialDateTime: starting,
                                            maximumYear: DateTime.now().year,
                                            minimumYear: 1900,
                                            onDateTimeChanged: (dateTime){
                                              setState(() {
                                                this.starting=dateTime;
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

                            //END
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor,),

                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: starting.difference(DateTime.now()).inDays==0? LocaleKeys.Ending.tr():DateFormat('dd/MM/yyyy').format(ending),//DateFormat('dd/MM/yyyy').format(hintBD),//dateTime.difference(DateTime.now()).inDays ==0 ? "Birthdate" : DateFormat('dd/MM/yyyy').format(dateTime),//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                                  hintStyle: TextStyle(color: ending.difference(DateTime.now()).inDays==0? Colors.grey.shade300 :Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onTap: (){showCupertinoModalPopup(context: context,
                                    builder: (context)=>CupertinoActionSheet(
                                      actions: [
                                        SizedBox(height: 180,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date, initialDateTime: ending,
                                            maximumYear: DateTime.now().year,
                                            minimumYear: 1900,
                                            onDateTimeChanged: (dateTime){
                                              setState(() {
                                                this.ending=dateTime;
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

                            SizedBox(
                              height: 10,
                            ),


                            GestureDetector(
                                onTap: () {_SelectImageDialog();},
                                child: Container(
                                  height: size.width * 0.8,
                                  width: size.width *0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: _image==null
                                      ?Center(child: FittedBox(fit: BoxFit.fitWidth,child: Text(LocaleKeys.clicktoupload.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20,),)))
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

                                tests=MyCertif_Add_Validator(context,reasons[position], starting, ending,_image,otherReasonController.text);


                                if(!tests)
                                {
                                  //ADD CERTIFICATE
                                  FirebaseFirestore.instance.collection('certificates').add(
                                    {"approved":"",
                                      "end":ending,
                                      "person":Code,
                                      "reason":reasonsEN[position],
                                      "sent":DateTime.now(),
                                      "start":starting,
                                      "refusal_reason":"",
                                      'OtherReason': otherReasonController.text.isEmpty?"":otherReasonController.text,

                                    },).then((value) {
                                      //ADD CERTIFICATE'S IMAGE TO THE FIREBASE STORAGE
                                    uploadImage(value.id);

                                    //ADD THE CORRESPONDING CODE
                                    final docUser = FirebaseFirestore.instance.collection('certificates').doc(value.id);
                                    //UPDATE THE FIELDS
                                    docUser.update({
                                      'code': value.id,
                                    });

                                    setState(() {_image=null;});
                                  });


                                  SentSuccessfullyAlert(context,LocaleKeys.Certificate.tr());

                                  initialisations();


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
                                  LocaleKeys.SEND.tr(),
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
                          ],
                        ),
                      ),
                    )),
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
              child: Text(LocaleKeys.ChoosePhoto.tr(),style: TextStyle(color: Colors.black),),
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
    final path = 'certifications/${id+".jpg"}';

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
