import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';

class ViewUserInfo extends StatefulWidget {
  late String code;
  late Widget image;
  late String email;
  late String first;
  late String last;
  late String Gender;
  late String phone;
  late String Department;
  late String address;
  late DateTime dateTime;

  ViewUserInfo({
    required this.code,
    required this.image,
    required this.email,
    required this.first,
    required this.last,
    required this.Gender,
    required this.phone,
    required this.Department,
    required this.address,
    required this.dateTime,
  });
  @override
  State<ViewUserInfo> createState() => _ViewUserInfoState();
}

class _ViewUserInfoState extends State<ViewUserInfo> {

  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }


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
    context.locale == Locale('en')?dept=List.from(deptEN):dept=List.from(deptFR);
    context.locale == Locale('en')?gender=List.from(genderEN):gender=List.from(genderFR);
  }

  @override
  void didChangeDependencies() {
    initialisations();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS
    return GestureDetector(
      onTap: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: widget.code,
        ),
        body: SafeArea(
          child: Expanded(
            child: Container(
              width: double.infinity,
              decoration: BackgroundImage(Theme.of(context)),
              child: SingleChildScrollView(
                child: Form(
                  child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          // PROFILE PICTURE
                          Container(
                            width: size.width / 3,
                            height: size.width / 3,

                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: ButtonColor(Theme.of(context))),
                              shape: BoxShape.circle,
                              color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,

                            ),

                            child: widget.image,

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
                              decoration: InputDecoration(
                                icon: Icon(CupertinoIcons.number),
                                hintText: widget.code,
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,
                              ),
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
                                enabled: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.alternate_email),
                                  hintText: widget.email,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
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
                                enabled: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.face),
                                  hintText: widget.first,
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
                                enabled: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.sort_by_alpha_rounded),
                                  hintText: widget.last,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
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
                              readOnly: true,
                              enabled: false,
                              decoration: InputDecoration(
                                icon: Icon(Icons.face),
                                hintText: gender[findIndex(genderEN, widget.Gender)],
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,),
                            ),),


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
                              enabled: false,
                              decoration: InputDecoration(
                                icon: Icon(Icons.map_outlined),
                                hintText: widget.address,//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,),
                            ),),

                          SizedBox(height: 10,),//SOME SPACING

                          //PHONE NUMBER FIELD
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: GestureDetector(
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone_android_rounded),
                                  hintText: widget.phone,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                              onDoubleTap: ()async{
                                final Uri url= Uri(scheme: 'tel', path: widget.phone);
                                await launchUrl(url);
                              },
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
                              enabled: false,
                              decoration: InputDecoration(
                                icon: Icon(Icons.work),
                                hintText: dept[findIndex(deptEN, widget.Department)],
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,),
                            ),),

                          SizedBox(
                            height: 40,
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
    );
  }
}
