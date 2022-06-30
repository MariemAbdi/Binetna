import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Carpooling/Carpooling_Model.dart';
import 'package:mae_application/Services/MyThemes.dart';

import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';
import 'AddOffer.dart';
import 'EditOffer.dart';
import 'ViewOffer.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({Key? key}) : super(key: key);

  @override
  State<MyOffers> createState() => _MyOffersState();
}

final user=GetStorage();

class _MyOffersState extends State<MyOffers> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{
        setState(() {
        });   },
      child: WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: (){ SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
          child: Scaffold(
              extendBodyBehindAppBar: true,
              body:  SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BackgroundImage(Theme.of(context)),
                  child: Column(
                    children:<Widget> [
                      SizedBox(height: 30,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Align(alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,
                            child: IconButton(icon: Icon(Icons.add),color: Colors.white,
                              onPressed: (){
                              Get.to(AddOffer());
                              },
                            ),

                          ),),
                      ),
                      Expanded(
                        child: StreamBuilder<List<CarpoolingModel>>(
                            stream: readCreatedOffers(user.read('code')),
                            builder: (context, snapshot) {
                              if(snapshot.data?.length==0){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontWeight: FontWeight.w800, fontSize: 25),),
                                    SizedBox(height:10),
                                    GestureDetector(child: Text(LocaleKeys.AddCarpooling.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontWeight: FontWeight.w800, fontSize: 20,decoration: TextDecoration.underline),),
                                      onTap: ()=>Get.to(AddOffer()),)
                                  ],
                                );
                              }

                              if (snapshot.hasError) {
                                return Text(
                                    LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800));
                              }
                              else if (snapshot.hasData) {
                                final offers = snapshot.data!;
                                return ListView.builder(
                                  itemCount: offers.length,
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      endActionPane: ActionPane(
                                        extentRatio: 1,
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(onPressed: (context) async {
                                            //DELETE OFFER
                                            final docUser = FirebaseFirestore.instance.collection('carpooling').doc(offers[index].id);
                                            docUser.delete();
                                          },
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            icon: Icons.clear,
                                            label:  LocaleKeys.Delete.tr(),
                                          )
                                        ],
                                      ),
                                      startActionPane: ActionPane(
                                        extentRatio: 1,
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(onPressed: (context){
                                            //UPDATE OFFER
                                            Get.to(EditOffer(id: offers[index].id,destinations: myDestinations(offers[index].destinations,),date: offers[index].day_time,list: offers[index].destinations,));

                                          },
                                            backgroundColor: Colors.orange,
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label:  LocaleKeys.Edit.tr(),),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: Tiles(Theme.of(context)),
                                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          leading:Row(mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text((index+1).toString(), style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context))),),
                                              ),
                                              VerticalDivider(color: ErrorColor(Theme.of(context)),),
                                            ],),
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(myDestinations(offers[index].destinations).substring(0,myDestinations(offers[index].destinations).length-1), style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context))),),
                                              SizedBox(height: 4,),

                                              Text(DateFormat('dd/MM/yyyy - kk:mm').format((offers[index].day_time)),style: TextStyle(color: ErrorColor(Theme.of(context)), overflow: TextOverflow.ellipsis),),

                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(alignment:Alignment.bottomRight,
                                                  child: Row(
                                                    children: [
                                                      Text(offers[index].places.toString(),style: TextStyle(fontWeight: FontWeight.w800,color: ErrorColor(Theme.of(context)))),
                                                      SizedBox(width: 2,),
                                                      Icon(Icons.people, size: 20,color: ErrorColor(Theme.of(context)),),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          onTap: (){
                                            //VIEW OFFER WITHOUT ONLY
                                            Get.to(ViewOffer(id: offers[index].id, person: offers[index].person, visibility: false, destinations: myDestinations(offers[index].destinations).substring(0,myDestinations(offers[index].destinations).length-1),people: offers[index].people,accepted: offers[index].accepted));

                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,));
                              }

                            }),
                      ),
                    ],
                  ),
                ),
              )

          ),
        ),
      ),
    );
  }
}
