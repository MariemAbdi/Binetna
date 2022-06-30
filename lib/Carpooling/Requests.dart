import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mae_application/Services/MyThemes.dart';
import 'package:get/get.dart' hide Trans;

import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';
import 'Carpooling_Model.dart';
import 'ViewPerson.dart';

class Requests extends StatefulWidget {

  late List<String> people;
  late String id;

  Requests({required this.people,required this.id});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

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
    super.didChangeDependencies();
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BackgroundImage(Theme.of(context)),
            child:
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BackgroundImage(Theme.of(context)),
              child:
              Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                 Expanded(child: StreamBuilder<List<CarpoolingModel>>(
                   stream: readSpecificOffer(widget.id),
                   builder: (context,AsyncSnapshot snapshot){
                     if(snapshot.hasData){
                       final docs = snapshot.data;
                       return ListView.builder(
                         itemCount: docs[0].people.length,
                           itemBuilder: (context, index) {
                         final list=docs[0].people;
                         return FutureBuilder(
                           future: FirebaseFirestore.instance.collection('users').doc(list[index]).get(),
                           builder:(context,AsyncSnapshot snap){
                             final user=snap.data;
                             if(snap.hasData){
                               return Slidable(
                                                    endActionPane: ActionPane(
                                                      extentRatio: 1,
                                                      motion: DrawerMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (context) async {
                                                            //REMOVE USER FROM OFFER
                                                            final Cardoc=FirebaseFirestore.instance.collection('carpooling').doc(widget.id);
                                                            Cardoc.update({
                                                              "people": FieldValue.arrayRemove([list[index]]),
                                                            });
                                                          },
                                                          backgroundColor: Colors.red,
                                                          foregroundColor: Colors.white,
                                                          icon: Icons.delete,
                                                          label: LocaleKeys.Delete.tr(),
                                                        )
                                                      ],
                                                    ),
                                                    startActionPane: ActionPane(
                                                      extentRatio: 1,
                                                      motion: DrawerMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (context) async {

                                                           FirebaseFirestore.instance.collection('carpooling').where('id',isEqualTo: widget.id).get().then((value) =>
                                                           value.docs.forEach((element) {

                                                             if(element['places']!=0){

                                                               //ADD TO ACCEPTED
                                                               final Cardoc=FirebaseFirestore.instance.collection('carpooling').doc(widget.id);
                                                               Cardoc.update({
                                                                 "people": FieldValue.arrayRemove([list[index]]),
                                                                 "accepted": FieldValue.arrayUnion([list[index]]),
                                                                 "places": FieldValue.increment(-1),
                                                               });
                                                             }else{
                                                               ScaffoldMessenger.of(context)
                                                                   .showSnackBar(SnackBar(
                                                                   content:
                                                                   Text(LocaleKeys.zeroplaces.tr())))
                                                                   .closed
                                                                   .then((value) => ScaffoldMessenger.of(context)
                                                                   .clearSnackBars());
                                                             }

                                                           }));



                                                          },
                                                          backgroundColor: MyThemes.darkgreen,
                                                          foregroundColor: Colors.white,
                                                          icon: Icons.check,
                                                          label: LocaleKeys.Approve.tr(),
                                                        )
                                                      ],
                                                    ),
                                 child: Container(
                                   decoration: Tiles(Theme.of(context)),
                                   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                   child: ListTile(
                                     title: Text(user['firstName']),
                                     subtitle: Text(dept[findIndex(deptEN, user['department'])]),
                                     onTap: (){
                                       Get.to(ViewPerson(code: user['code']));
                                     },
                                   ),
                                 ),
                               );
                             }
                             return Container();
                           }
                         );
                       });
                     }
                        return CircularProgressIndicator();

                    },
                 ))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
