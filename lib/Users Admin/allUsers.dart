import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Services/MyThemes.dart';

import '../Profile/User.dart';
import '../Services/My_Services.dart';
import '../Services/storage_service.dart';
import '../translations/locale_keys.g.dart';
import 'ViewUserInfo.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(String img_path, String gender){
    return FutureBuilder(
      future:storage.downloadURL("profile pictures",img_path+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(!snapshot.hasData){
          return CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NoImage(gender),);
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return ClipOval(
            child: Image.network(snapshot.data!, fit: BoxFit.cover,),
          );
        }
        if(snapshot.connectionState==ConnectionState.waiting){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}
        return Container();
      },
    );
  }

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
          onTap: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
          child: Scaffold(
              extendBodyBehindAppBar: true,
              body:  SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BackgroundImage(Theme.of(context)),
                  child: Expanded(
                    child: StreamBuilder<List<User>>(
                        stream: readUsers(true),
                        builder: (context, snapshot) {
                          if(snapshot.data?.length==0){return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),),);}

                          if (snapshot.hasError) {
                            return Text(
                                LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w800));
                          }
                          else if (snapshot.hasData) {
                            final users = snapshot.data!;
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: Tiles(Theme.of(context)),
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    leading:Row(mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(users[index].code, style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context))),overflow: TextOverflow.ellipsis,),
                                        ),
                                        VerticalDivider(color: ErrorColor(Theme.of(context)),),
                                      ],),

                                    title:Text(users[index].firstName+" "+users[index].lastName, style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context))),overflow: TextOverflow.ellipsis,),

                                    onTap: (){
                                      //VIEW ACCOUNT'S INFORMATION
                                      Get.to(ViewUserInfo(code: users[index].code, image: retrieveImage(users[index].code, users[index].gender), email: users[index].mail, first: users[index].firstName, last: users[index].lastName, Gender: users[index].gender, phone: users[index].phone, Department: users[index].department, address: users[index].address, dateTime: users[index].birthdate));

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
}
