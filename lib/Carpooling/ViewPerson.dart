import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Appbar/Header.dart';
import '../Services/My_Services.dart';

class ViewPerson extends StatefulWidget {
  late String code;
   ViewPerson({required this.code});

  @override
  State<ViewPerson> createState() => _ViewPersonState();
}

class _ViewPersonState extends State<ViewPerson> {

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

  int findIndex(List<String> list, String text) {
    final index = list.indexWhere((element) => element == text);
    return index;
  }

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?dept=List.from(deptEN):dept=List.from(deptFR);
    //fillList();
    super.didChangeDependencies();
  }


  late String first="";
  late String last="";
  late String phone="";
  late String Department="";

  _FetchData() async {
      FirebaseFirestore.instance
          .collection('users')
          .where('code', isEqualTo:widget.code)
          .get()
          .then((value) =>
          value.docs.forEach((element) {
            setState(() {
              first=element['firstName'];
              last=element['lastName'];
              phone=element['phone'];
              Department=dept[findIndex(deptEN, element['department'])];
            });
          }));

  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    _FetchData();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersiveSticky, overlays: []);
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
              height: double.infinity,
              decoration: BackgroundImage(Theme.of(context)),
              child: SingleChildScrollView(
                child: Form(
                  child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[

                          SizedBox(height: MediaQuery.of(context).size.height/14,),
                          //FIRST NAME FIELD
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                                  hintText: first,
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
                                  icon: Icon(Icons.sort_by_alpha_rounded),
                                  hintText: last,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          //SOME SPACE
                          SizedBox(
                            height: 10,
                          ),

                          //PHONE NUMBER FIELD
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone_android_rounded),
                                  hintText: phone,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            onDoubleTap: ()async{
                              final Uri url= Uri(scheme: 'tel', path: phone);
                              await launchUrl(url);
                            },
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
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,),
                            child: TextFormField(
                              readOnly: true,
                              enabled: false,
                              decoration: InputDecoration(
                                icon: Icon(Icons.work),
                                hintText: Department,
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
