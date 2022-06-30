import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Services/FullScreen.dart';

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/storage_service.dart';

class viewCertif extends StatefulWidget {

  late String code;
  late String person;
  late String reason;
  late DateTime start;
  late DateTime end;
  late String? refusal_reason;
  late String? otherReason;

  viewCertif({
    required this.code,
    required this.person,
    required this.reason,
    required this.start,
    required this.end,
    required this.refusal_reason,
    required this.otherReason,
  });


  @override
  State<viewCertif> createState() => _viewCertifState();
}

class _viewCertifState extends State<viewCertif> {

  late String First="";
  late String Last="";
  late String Department="";
  late String Phone="";

  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('code',isEqualTo: widget.person).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            First=element['firstName'];
            Last=element['lastName'];
            pos=findIndex(deptEN, element['department']);
            Phone=element['phone'];
          });
        }));}

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(){
    return FutureBuilder(
      future:storage.downloadURL("certifications",widget.code+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting){return Container(width:15,height: 15,child: Center(child: FittedBox(fit: BoxFit.fitWidth,child: CircularProgressIndicator(color: MyThemes.darkgreen,)),));}

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

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?dept=List.from(deptEN):dept=List.from(deptFR);
    context.locale == Locale('en')?reasons=List.from(reasonsEN):reasons=List.from(reasonsFR);
    super.didChangeDependencies();
  }

  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
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
          title: widget.person,
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
                        children: [

                          SizedBox(
                            height: 40,
                          ),

                          //PERSON FIELD
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
                        ),

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
                                  hintText: dept[pos],
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

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //REASON FIELD
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
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                icon: Icon(Icons.medical_services),
                                hintText: reasons[findIndex(reasonsEN, widget.reason)],
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),


                          Visibility(
                            visible: widget.reason?.compareTo(reasonsEN[reasonsEN.length-1])==0?true:false,
                            child: SizedBox(
                              height: 10,
                            ),
                          ), //SOME

                          //OTHER REASON FIELD
                          Visibility(
                            visible: widget.reason?.compareTo(reasonsEN[reasonsEN.length-1])==0?true:false,
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
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.question_mark),
                                    hintText: widget.otherReason,
                                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //START FIELD
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
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                icon: Icon(Icons.date_range),
                                hintText: DateFormat('dd/MM/yyyy').format((widget.start)),
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //END FIELD
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
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                icon: Icon(Icons.date_range),
                                hintText: DateFormat('dd/MM/yyyy').format((widget.end)),
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          // REFUSAL REASON IF IT EXISTS
                          Visibility(
                            visible: widget.refusal_reason==null || widget.refusal_reason!.isEmpty?false:true,
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
                                onDoubleTap: (){
                                  Get.to(FullScreen(folder:"certifications",imageName: widget.code+".jpg",));
                                },
                                child: Container(
                                  height: size.width * 0.8,
                                  width: size.width *0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: retrieveImage(),
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
    );
  }
}
