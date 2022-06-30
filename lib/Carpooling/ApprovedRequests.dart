import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;

import '../Services/My_Services.dart';
import 'Carpooling_Model.dart';
import 'ViewPerson.dart';

class ApprovedRequests extends StatefulWidget {
  late List<String> people;
  late String id;

  ApprovedRequests({required this.people,required this.id});

  @override
  State<ApprovedRequests> createState() => _ApprovedRequestsState();
}

class _ApprovedRequestsState extends State<ApprovedRequests> {

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
                            itemCount: docs[0].accepted.length,
                            itemBuilder: (context, index) {
                              final list=docs[0].accepted;
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance.collection('users').doc(list[index]).get(),
                                  builder:(context,AsyncSnapshot snap){
                                    final user=snap.data;
                                    if(snap.hasData){
                                      return Container(
                                        decoration: Tiles(Theme.of(context)),
                                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        child: ListTile(
                                          title: Text(user['firstName']),
                                          subtitle: Text(dept[findIndex(deptEN, user['department'])]),
                                          onTap: (){
                                            Get.to(ViewPerson(code: user['code']));
                                          },
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
