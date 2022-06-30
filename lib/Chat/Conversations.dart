import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Chat/Chat_Screen.dart';
import 'package:mae_application/Services/MyThemes.dart';
import 'package:get/get.dart' hide Trans;
import 'package:timeago/timeago.dart' as timeago;

import '../Services/My_Services.dart';
import '../Services/storage_service.dart';
import '../translations/locale_keys.g.dart';


class Conversations extends StatefulWidget {
  // late String receiverGender;
  // Conversations({required this.receiverGender});

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {

  final thisUser=GetStorage();

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(img_path,gender){
    return FutureBuilder(
      future:storage.downloadURL("profile pictures",img_path+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(!snapshot.hasData) return CircleAvatar(radius: 40,backgroundColor: Colors.white, backgroundImage: NoImage(gender),);
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(snapshot.data!,),
          );
        }
        if(snapshot.connectionState==ConnectionState.waiting){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}
        return Container();
      },
    );
  }

  timeAgo(DateTime dt){
    if(DateTime.now().difference(dt).inDays>=2 && DateTime.now().difference(dt).inDays<7)
    return DateFormat('EEEEE', LocaleKeys.timeago.tr()).format(dt);
    else if (DateTime.now().difference(dt).inDays<=1)
    return timeago.format(dt,locale: LocaleKeys.timeago.tr());
    else
      return DateFormat('dd/MM/yyyy').format((dt));
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{
        setState(() {
        });
      },
      child: WillPopScope(
          onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BackgroundImage(Theme.of(context)),
                child:Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(thisUser.read('code')).collection('messages').orderBy("last_date",descending: true).snapshots(),
                        builder: (context,AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data.docs.length<1){
                              return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),),);
                            }
                            return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context,index){
                                  final receiverId=snapshot.data.docs[index].id;
                                  final lastmsg= snapshot.data.docs[index]['last_message'];
                                  final dateTime=snapshot.data.docs[index]['last_date'].toDate();
                                  return FutureBuilder(
                                    future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                                    builder: (context,AsyncSnapshot asyncSnapshot){
                                      if(asyncSnapshot.hasData){
                                        var receiver=asyncSnapshot.data;
                                        return Container(
                                          decoration: Tiles(Theme.of(context)),
                                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              child: retrieveImage(receiverId, receiver['gender']),
                                            ),
                                            title: Text(receiver['firstName']+" "+ receiver["lastName"], style: TextStyle(color: ErrorColor(Theme.of(context)), overflow: TextOverflow.ellipsis),),
                                            subtitle: Container(
                                              child: Text(
                                                lastmsg.contains("https://firebasestorage")
                                                    ?"Image":lastmsg
                                                , style: TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis),),
                                            ),
                                            trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(timeAgo(dateTime),style: TextStyle(color: Colors.grey.shade700, overflow: TextOverflow.ellipsis),),
                                            ],),
                                            onTap: (){
                                              Get.to(ChatScreen(receiverid: receiverId,receiverimage:retrieveImage(receiverId,receiver['gender']), receivername: receiver['firstName']+" "+ receiver["lastName"],),);
                                            },
                                          ),
                                        );
                                      }return LinearProgressIndicator(color: MyThemes.darkgreen,);
                                    },

                                  );
                                });
                          }
                          return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);
                        },
                      ),
                    ),
                  ],
                ),
              ),)
            )


          ),
      ),
      ),
    );
  }
}
