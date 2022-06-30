import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Carpooling/RequestedJoins.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Appbar/Header.dart';
import '../Services/My_Services.dart';

class ViewOffer extends StatefulWidget {
  late String id;
  late String person;
  late bool visibility;
  late String destinations;
  late List<String> people;
  late List<String> accepted;


  ViewOffer({
    required this.id,
    required this.person,
    required this.visibility,
    required this.destinations,
    required this.people,
    required this.accepted,
  });
  @override
  State<ViewOffer> createState() => _ViewOfferState();
}

class _ViewOfferState extends State<ViewOffer> {

  final placesController = TextEditingController();
  final destinationsController = TextEditingController();
  final daytimeController = TextEditingController();
  final conditionsController = TextEditingController();

  final user=GetStorage();

  late String First="";
  late String Last="";
  late String Department="";
  late String Phone="";
  late DateTime date_time;

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
  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('code',isEqualTo: widget.person).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            First=element['firstName'];
            Last=element['lastName'];
            Department=dept[findIndex(deptEN, element['department'])];
            Phone=element['phone'];
          });
        }));}

  late bool _visible;
  late bool _cdts=false;

  void initialisations() async{
    FirebaseFirestore.instance.collection('carpooling').where('id',isEqualTo: widget.id).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            placesController.text=(element['places']).toString();
            daytimeController.text=DateFormat('dd/MM/yyyy - kk:mm').format((element['day_time']).toDate());
            date_time=(element['day_time']).toDate();
            destinationsController.text=widget.destinations;
            conditionsController.text=element['conditions'];

            if(element['person'].compareTo(user.read('code'))==0 && DateTime.now().difference(date_time).inMinutes <= 0) {
              _cdts=true;
            }

          });
        }));}


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    setState(() {
      _visible=widget.visibility;
    });
    _fetchData();
    initialisations();
  }

  @override
  void dispose() {
    placesController.dispose();
    destinationsController.dispose();
    daytimeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS

    return GestureDetector(
      onTap: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: destinationsController.text,
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
                        children: [
                          Visibility(
                            visible: _cdts,
                            child: Align(alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.info),
                              onPressed: (){
                                Get.to(RequestedJoins(people: widget.people, id: widget.id,accepted: widget.accepted,));
                              },
                            ),),
                          ),
                          Visibility(
                              visible: !_cdts,

                              child: SizedBox(height: 30,)),

                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(LocaleKeys.staysafe.tr(),  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.red),)),
                          SizedBox(height: 10,),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(LocaleKeys.OfferedBy.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),)),
                          SizedBox(height: 20,),

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

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //DAYTIME FIELD
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
                                maxLines: null,
                                controller: daytimeController,
                                keyboardType: TextInputType.multiline,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.date_range),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //DESTINATIONS FIELD
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
                                maxLines: null,
                                controller: destinationsController,
                                keyboardType: TextInputType.multiline,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.directions_car),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //REMAINING PLACES FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                              enabled: false,
                              controller: placesController,
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                icon: Icon(Icons.people),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //CONDITIONS FIELD
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
                                style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800,fontSize: 16),
                                enabled: false,
                                maxLines: null,
                                controller: conditionsController,
                                keyboardType: TextInputType.multiline,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.warning, color: Colors.red,),
                                  border: InputBorder.none,
                                  hintText: LocaleKeys.NothingToDisplay.tr(),
                                  hintStyle: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Visibility(
                            visible: _visible,
                            child: InkWell(
                              onTap: () async {
                                // IF USER JOINED ANOTHER OFFER ALREADY WE REMOVE IT
                                FirebaseFirestore.instance
                                    .collection('carpooling').where("people", arrayContains: user.read('code'))
                                    .where("id", isNotEqualTo: widget.id).get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {

                                    DateTime date=doc['day_time'].toDate();
                                    if(date_time.year.compareTo(date.year)==0 && date_time.month.compareTo(date.month)==0 && date_time.day.compareTo(date.day)==0)
                                      // REMOVE OCCURENCY
                                      {
                                      final Cardoc=FirebaseFirestore.instance.collection('carpooling').doc(doc['id']);
                                      Cardoc.update({
                                          "people": FieldValue.arrayRemove([user.read('code')]),
                                      });

                                    }
                                  });
                                });


                                // IF USER JOINED ANOTHER OFFER ALREADY WE REMOVE IT
                                FirebaseFirestore.instance
                                    .collection('carpooling').where("accepted", arrayContains: user.read('code'))
                                    .where("id", isNotEqualTo: widget.id).get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {

                                    DateTime date=doc['day_time'].toDate();
                                    if(date_time.year.compareTo(date.year)==0 && date_time.month.compareTo(date.month)==0 && date_time.day.compareTo(date.day)==0)
                                      // REMOVE OCCURENCY
                                        {
                                      final Cardoc=FirebaseFirestore.instance.collection('carpooling').doc(doc['id']);
                                      Cardoc.update({
                                        "accepted": FieldValue.arrayRemove([user.read('code')]),
                                        "places": FieldValue.increment(1),
                                      });

                                    }
                                  });
                                });



                                // JOIN CURRENT OFFER
                               final Offerdoc=FirebaseFirestore.instance.collection('carpooling').doc(widget.id);
                                Offerdoc.update({
                                    "people": FieldValue.arrayUnion([user.read('code')]),
                                  });

                                // REFRESH DATA
                                placesController.text= (int.parse(placesController.text) -1 ).toString();
                                // ALREADY JOINED => INVISIBLE
                                setState(() {
                                  _visible=!_visible;
                                });


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
                                  LocaleKeys.JOIN.tr(),
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
    );
  }
}
