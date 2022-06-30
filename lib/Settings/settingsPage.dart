import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Appbar/Header.dart';
import 'package:mae_application/Services/MyThemes.dart';
import 'package:mae_application/SideBar/SideBar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  final language = GetStorage();

  String dropdownValue=LocaleKeys.Language.tr();
  late bool isSwitched=true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return GestureDetector(
     onTap: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: LocaleKeys.Settings.tr(),
        ),
        drawer: MySideBar(),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BackgroundImage(Theme.of(context)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  alignment: FractionalOffset.center,
                  padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.Language.tr(), style: TextStyle(fontSize: 18, color: Colors.white),),

                        DropdownButton<String>(
                          dropdownColor: Colors.grey,
                            value: dropdownValue,
                            icon: Icon(Icons.keyboard_arrow_down,color: Colors.white,),


                            items: <String>[LocaleKeys.Language.tr(),'English', 'Français'].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(value:  value,
                                    child: Text(value,style: TextStyle(color: Colors.white),),);
                                }).toList(),
                            onChanged: (String? newValue) async {
                          setState(() {
                            dropdownValue=newValue!;
                          });

                          if (dropdownValue.compareTo("English")==0) {
                            final _newLocale = Locale('en',);
                            await context.setLocale(_newLocale); // change `easy_localization` locale
                            await Get.updateLocale(_newLocale); // change `Get` locale direction


                            setState(() async {
                              await context.setLocale(Locale('en'));
                            });


                            LanguageChoice(context, "English");
                              }
                          else{
                            final _newLocale = Locale('fr',);
                            await context.setLocale(_newLocale); // change `easy_localization` locale
                            await Get.updateLocale(_newLocale); // change `Get` locale direction

                            LanguageChoice(context,"Français");
                          }
                            })
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.Notifications.tr(),style: TextStyle(fontSize: 18,color: Colors.white),),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              if (isSwitched){
                                FirebaseMessaging.instance.subscribeToTopic("notifications");
                                FirebaseMessaging.instance.subscribeToTopic("carpooling");
                              }else{
                                FirebaseMessaging.instance.unsubscribeFromTopic("notifications");
                                FirebaseMessaging.instance.unsubscribeFromTopic("carpooling");
                              }
                            });
                          },
                          activeTrackColor: Colors.white,
                          activeColor: MyThemes.lightgreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
