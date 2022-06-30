import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/Services/FullScreen.dart';
import 'package:mae_application/Services/Validators.dart';
import 'package:mae_application/translations/locale_keys.g.dart';
import 'package:get/get.dart' hide Trans;

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/storage_service.dart';


class MedForm extends StatefulWidget {

  late String code;//to get the image
  late String person;
  late DateTime start;
  late DateTime end;
  late String reason;
  late String refusal_reason;
  late bool update;

  MedForm({required this.code,required this.reason, required this.person, required this.start, required this.end,required this.refusal_reason, required this.update});

  @override
  State<MedForm> createState() => _MedFormState();
}

class _MedFormState extends State<MedForm> {
  //THE FORM KEY
  final _formKey = GlobalKey<FormState>();

  final otherReasonController = TextEditingController();

  //START INITIAL VALUE
  DateTime starting = DateTime.now();

  //END INITIAL VALUE
  DateTime ending = DateTime.now();


  //CATEGORY DROPDOWN
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

  //PICKED IMAGE
  XFile? _image;

  int findIndex(List<String> list, String text) {
    final index = list.indexWhere((element) => element == text);
    return index;
  }
  //SHARED PREFRENCES
  final userdata=GetStorage();

  late String First="";
  late String Last="";
  late String Department="";
  late String Phone="";


  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: userdata.read('mail')).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            First=element['firstName'];
            Last=element['lastName'];
            Department=element['department'];
            Phone=element['phone'];
          });
        }));
  }

  initialisations() {
    setState(() {
      starting= widget.start;
      ending= widget.end;
      position = findIndex(reasonsEN, widget.reason);
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    initialisations();
    _fetchData();
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

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(){
    return FutureBuilder(
      future:storage.downloadURL("certifications",widget.code+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return ClipRRect(
            //borderRadius: BorderRadius.circular(20),
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          );
        }

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
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: MyAppBar(
            title: widget.reason,
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
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: widget.person,
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
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  enabled: false,
                                  keyboardType: TextInputType.name,
                                  maxLines: null,
                                  cursorColor: Colors.black,
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
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  enabled: false,
                                  keyboardType: TextInputType.name,
                                  maxLines: null,
                                  cursorColor: Colors.black,
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
                                  keyboardType: TextInputType.text,
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
                                  keyboardType: TextInputType.number,
                                  maxLines: null,
                                  cursorColor: Colors.black,
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
                                enabled: widget.update,
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.medical_services),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: reasons[position], //gender[position],
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
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
                                      hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
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
                                enabled: widget.update,
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: DateFormat('dd/MM/yyyy').format(starting),//DateFormat('dd/MM/yyyy').format(hintBD),//dateTime.difference(DateTime.now()).inDays ==0 ? "Birthdate" : DateFormat('dd/MM/yyyy').format(dateTime),//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
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
                                enabled: widget.update,
                                readOnly: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                  hintText: DateFormat('dd/MM/yyyy').format(ending),//DateFormat('dd/MM/yyyy').format(hintBD),//dateTime.difference(DateTime.now()).inDays ==0 ? "Birthdate" : DateFormat('dd/MM/yyyy').format(dateTime),//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
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

                            // REFUSAL REASON IF IT EXISTS
                            Visibility(
                              visible: (widget.refusal_reason.isEmpty || widget.refusal_reason.isEmpty)?false:true,
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
                                    enabled: false,
                                    keyboardType: TextInputType.name,
                                    maxLines: null,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.delete_forever),
                                      hintText: widget.refusal_reason,
                                      hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10,),

                            GestureDetector(
                              onDoubleTap: (){Get.to(FullScreen(imageName: widget.code+".jpg", folder: "certifications"));},
                                onTap: () {widget.update?_SelectImageDialog():null;},
                                child: Container(
                                  height: size.width * 0.8,
                                  width: size.width *0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: _image==null?retrieveImage()
                                  :Image(image: FileImage(File(_image!.path)),fit: BoxFit.cover,),
                                )),

                            SizedBox(
                              height: 10,
                            ),

                            Visibility(
                              visible: widget.update,
                              child: InkWell(
                                onTap: () async {

                                  FocusScope.of(context).unfocus();

                                  _formKey.currentState!.save();

                                  bool tests = false;

                                  //FIELD VALIDATION
                                  tests=MyCertif_Edit_Validator(context,reasons[position], starting, ending,otherReasonController.text);

                                  if(!tests)
                                  {
                                    //UPDATE THE SENT DATE
                                    final docUser = FirebaseFirestore.instance.collection('certificates').doc(widget.code);
                                    docUser.update({
                                      'sent': DateTime.now(),
                                      'start': starting,
                                      'end': ending,
                                      'reason': reasonsEN[position],
                                      'OtherReason': otherReasonController.text.isEmpty?"":otherReasonController.text,
                                    });

                                    //RESET FIELDS
                                    setState(() {
                                      widget.start=starting;
                                      widget.end=ending;
                                      widget.reason=reasons[position];
                                    });
                                    initialisations();

                                    UpdateSuccessAlert(context);

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
                            ),

                            SizedBox(
                              height: 40,
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
                setState(() {

                });
              },
              child: Text(LocaleKeys.TakePhoto.tr(),style: TextStyle(color: Colors.black),),
            ),

            // CHOOSE A PHOTO : GALLERY
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.gallery);
                setState(() {

                });
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

  Future uploadImage() async{
    final file = File(_image!.path);
    final path = 'certifications/${widget.code+".jpg"}';

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
}

