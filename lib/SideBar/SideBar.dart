import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Carpooling/Carpooling.dart';
import 'package:mae_application/Post%20Admin/PostManager.dart';
import 'package:mae_application/translations/locale_keys.g.dart';
import '../Certif Admin/CertificationManager.dart';
import '../Chat/Chat.dart';
import '../HomePage/Home.dart';
import '../MedicalCertif/mycertifs.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/storage_service.dart';
import '../Settings/settingsPage.dart';
import '../Users Admin/UsersManagement.dart';
import 'SideBar_Item.dart';
import 'SideBarHeaderWidget.dart';

class MySideBar extends StatefulWidget {
  const MySideBar({Key? key}) : super(key: key);

  @override
  State<MySideBar> createState() => _MySideBarState();
}

class _MySideBarState extends State<MySideBar> {

  final userdata=GetStorage();
  late String name="";
  late String mail="";
  late String img_path="";
  late bool isCertifAdmin=false;
  late bool isPostAdmin=false;
  late bool isUserAdmin=false;


  //GENDER DROPDOWN
  int position=0;
  static List<String> genderEN = [
    "Gender",
    "Female",
    "Male",];


  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(){
    return FutureBuilder(
      future:storage.downloadURL("profile pictures",img_path),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(!snapshot.hasData){
          return CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NoImage(genderEN[position]),);
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return ClipOval(
            child: Image.network(snapshot.data!, fit: BoxFit.cover,),
          );
        }
        if(snapshot.connectionState==ConnectionState.waiting || !snapshot.hasData){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}
        return Container();
      },
    );
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

    //GET NEEDED INFORMATION FROM DATABASE
    FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: userdata.read('mail')).get().then((value) =>
    value.docs.forEach((element) {
      setState(() {
        name=element["firstName"];
        mail=userdata.read('mail');
        img_path=element['code']+".jpg";
        position=findIndex(genderEN, element["gender"]);
      });
    }));

    //CHECK FOR ROLE
    if(userdata.read("role")==null) {}
    else if("certifs".compareTo(userdata.read("role"))==0)
      {setState(() {isCertifAdmin=true;});}
    else if("posts".compareTo(userdata.read("role"))==0)
    {setState(() {isPostAdmin=true;});}
    else if("users".compareTo(userdata.read("role"))==0)
    {setState(() {isUserAdmin=true;});}


  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
    child: Drawer(
        child: Material(
          color: Theme.of(context).primaryColorDark,
          child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SideBarHeaderWidget(mail: mail , name: name, img: retrieveImage(),),
                        SizedBox(height: 10,),
                        Divider(thickness: 1,height: 10, color: Colors.grey,),
                        SizedBox(height: 20,),

                        MenuItem(
                            text: LocaleKeys.HomePage.tr(),
                            icon: Icons.home,
                            onPressed: () => onItemPressed(context,index: 0)),
                        SizedBox(height: 30,),

                        MenuItem(
                            text: LocaleKeys.Messages.tr(),
                            icon: Icons.message,
                            onPressed: () => onItemPressed(context,index: 1)),
                        SizedBox(height: 30,),


                        MenuItem(
                            text: LocaleKeys.mycertificates.tr(),
                            icon: Icons.medical_services,
                            onPressed: () => onItemPressed(context,index: 2)),
                        SizedBox(height: 30,),


                        Visibility(
                          visible: isPostAdmin,
                          maintainSize: isPostAdmin,
                          maintainAnimation: isPostAdmin,
                          maintainState: isPostAdmin,
                          child: MenuItem(
                              text: LocaleKeys.Posts.tr(),
                              icon: Icons.edit,
                              onPressed: () => onItemPressed(context,index: 3)),
                        ),
                        Visibility(
                            visible: isPostAdmin,
                            maintainSize: isPostAdmin,
                            maintainAnimation: isPostAdmin,
                            maintainState: isPostAdmin,
                            child: SizedBox(height: 30,)),

                        Visibility(
                          visible: isCertifAdmin,
                          maintainSize: isCertifAdmin,
                          maintainAnimation: isCertifAdmin,
                          maintainState: isCertifAdmin,
                          child: MenuItem(
                              text: LocaleKeys.ManageCertificates.tr(),
                              icon: Icons.approval,
                              onPressed: () => onItemPressed(context,index: 4)),
                        ),
                        Visibility(
                            visible: isCertifAdmin,
                            maintainSize: isCertifAdmin,
                            maintainAnimation: isCertifAdmin,
                            maintainState: isCertifAdmin,
                            child: SizedBox(height: 30,)),

                        Visibility(
                          visible: isUserAdmin,
                          maintainSize: isUserAdmin,
                          maintainAnimation: isUserAdmin,
                          maintainState: isUserAdmin,
                          child: MenuItem(
                              text: LocaleKeys.Users.tr(),
                              icon: Icons.people,
                              onPressed: () => onItemPressed(context,index: 5)),
                        ),
                        Visibility(
                            visible: isUserAdmin,
                            maintainSize: isUserAdmin,
                            maintainAnimation: isUserAdmin,
                            maintainState: isUserAdmin,
                            child: SizedBox(height: 30,)),


                        MenuItem(
                            text: LocaleKeys.Carpooling.tr(),
                            icon: Icons.car_repair,
                            onPressed: () => onItemPressed(context,index: 6)),
                        SizedBox(height: 30),
                        MenuItem(
                            text: LocaleKeys.Settings.tr(),
                            icon: Icons.settings,
                            onPressed: () => onItemPressed(context,index: 7)),



                        SizedBox(height: 20,),
                        Divider(thickness: 1,height: 10,color: Colors.grey,),
                        SizedBox(height: 30),
                        MenuItem(
                            text: LocaleKeys.LOGOUT.tr(),
                            icon: Icons.power_settings_new_rounded,
                            onPressed: () => onItemPressed(context,index: 8)),

                        SizedBox(height: 30),
                        MenuItem(
                            text: LocaleKeys.QuitApp.tr(),
                            icon: Icons.exit_to_app_rounded,
                            onPressed: () => onItemPressed(context,index: 9)),

                        SizedBox(height: 40,),

                      ],
                    ),
                  ),
                ),
              )

          ),),
  );

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);
    switch(index){
      case 0:
        Get.to(HomePage(),transition: Transition.rightToLeft,);
        break;
      case 1:
        Get.to(Chat(),transition: Transition.rightToLeft,);
        break;
      case 2 :
        Get.to(MyCertifs(),transition: Transition.rightToLeft,);
        break;
      case 3:
        Get.to(PostManager(),transition: Transition.rightToLeft,);
            break;
      case 4:
        Get.to(certif_management(),transition: Transition.rightToLeft);
        break;
      case 5:
        Get.to(User_Management(),transition: Transition.rightToLeft);
        break;
      case 6:
        Get.to(Carpooling(),transition: Transition.rightToLeft);
        break;
      case 7:
        Get.to(settings(),transition: Transition.rightToLeft);
        break;
      case 8:
        LogOutAlert(context);
        break;
      case 9:
        QuitAppAlert(context);
        break;


  }

  }
}




