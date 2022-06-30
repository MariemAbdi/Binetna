import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Carpooling/Carpooling_Model.dart';
import 'package:mae_application/Carpooling/ViewOffer.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';

class AllOffers extends StatefulWidget {
  const AllOffers({Key? key}) : super(key: key);

  @override
  State<AllOffers> createState() => _AllOffersState();
}

class _AllOffersState extends State<AllOffers> {
  final user=GetStorage();

  @override
  void initState() {
    super.initState();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: RefreshIndicator(
        color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
        backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
        onRefresh: ()async{

          setState(() {

          });   },
        child: GestureDetector(
          onTap: (){
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
          },
          child: Scaffold(
              extendBodyBehindAppBar: true,
              body:  SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BackgroundImage(Theme.of(context)),
                  child: Expanded(
                    child: StreamBuilder<List<CarpoolingModel>>(
                        stream: readOffers(),
                        builder: (context, snapshot) {
                          if(snapshot.data?.length==0){return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),));}

                          if (snapshot.hasError) {
                            return Text(
                                LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800));
                          }
                          else if (snapshot.hasData) {
                            final offers = snapshot.data!;
                            return ListView.builder(
                              itemCount: offers.length,
                              itemBuilder: (context, index) {
                                return Container(
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
                                      ],
                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(myDestinations(offers[index].destinations).substring(0,myDestinations(offers[index].destinations).length-1), style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context)), overflow: TextOverflow.ellipsis),),
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
                                      // USER CAN'T JOIN OFFER IF THEY OWN IT, IF THE PLACES ARE EQUAL TO 0 OR IF DATE IS PASSED OR IF PERSON IS ALREADY IN OFFER
                                      if((offers[index].person.compareTo(user.read('code'))==0)||(offers[index].places==0)
                                          ||(offers[index].day_time.difference(DateTime.now()).inDays<0)||(findIndex(offers[index].people, user.read('code'))!=-1)||(findIndex(offers[index].accepted, user.read('code'))!=-1))
                                        {//VIEW OFFER WITHOUT GETTING THE OPTION TO JOIN IT
                                          Get.to(ViewOffer(id: offers[index].id, person: offers[index].person, visibility: false, destinations: myDestinations(offers[index].destinations).substring(0,myDestinations(offers[index].destinations).length-1),people: offers[index].people,accepted: [],));

                                        }else if (offers[index].person.compareTo(user.read('code'))==0){
                                        Get.to(ViewOffer(id: offers[index].id, person: offers[index].person, visibility: false, destinations: myDestinations(offers[index].destinations).substring(0,myDestinations(offers[index].destinations).length-1),people: offers[index].people,accepted: [],));
                                      }
                                      else{
                                        //VIEW THE OFFER WITH THE ABILITY TO JOIN
                                        Get.to(ViewOffer(id: offers[index].id, person: offers[index].person, visibility: true, destinations: myDestinations(offers[index].destinations).substring(0,myDestinations(offers[index].destinations).length-1),people: offers[index].people,accepted: [],));

                                      }


                                    },
                                  ),

                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,));
                          }

                        }),
                  ),
                ),
              )

          ),
        ),
      ),
    );
  }
  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }
}
