import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mae_application/Carpooling/Accepted.dart';

import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/Theme_Service.dart';
import '../SideBar/SideBar.dart';
import '../translations/locale_keys.g.dart';
import 'AllOffers.dart';
import 'JoinedOffers.dart';
import 'MyOffers.dart';

class Carpooling extends StatefulWidget {
  const Carpooling({Key? key}) : super(key: key);

  @override
  State<Carpooling> createState() => _CarpoolingState();
}

class _CarpoolingState extends State<Carpooling> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,

            title: Text(LocaleKeys.Carpooling.tr(),style: TextStyle(overflow: TextOverflow.ellipsis),),

            centerTitle: true,

            bottom: TabBar(
              tabs: [
                Tab(text: LocaleKeys.AllOffers.tr() , icon: Icon(Icons.car_repair, ),),
                Tab(text: LocaleKeys.JoinedOffers.tr(),icon: Icon(Icons.directions_car_rounded,),),
                Tab(text: LocaleKeys.accepted.tr(),icon: Icon(Icons.check,),),
                Tab(text: LocaleKeys.MyOffers.tr(),icon: Icon(Icons.car_rental,),),

              ],
            ),
            actions: [
              //CHANGE THE APP'S THEME ICON
              GestureDetector(
                child: Icon(Theme.of(context).brightness==MyThemes.lightTheme.brightness ? Icons.brightness_3_sharp : Icons.wb_sunny),
                //WE CALL THE THEME SWITCHER METHOD
                onTap: (){ThemeService().switchTheme();

                ThemeSwitchedAlert(context);
                },

              ),

              //Spacing
              SizedBox(width: 20,),
            ],
          ),

          drawer: MySideBar(),
          body: TabBarView(children: [
            AllOffers(),
            Joined(),
            Accepted(),
            MyOffers(),

          ]),
        ),
    );
  }
}
