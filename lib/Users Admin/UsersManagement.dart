import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Services/My_Services.dart';

import '../Services/Theme_Service.dart';
import '../SideBar/SideBar.dart';
import '../translations/locale_keys.g.dart';
import 'Requested.dart';
import 'allUsers.dart';

class User_Management extends StatefulWidget {
  const User_Management({Key? key}) : super(key: key);

  @override
  State<User_Management> createState() => _User_ManagementState();
}

class _User_ManagementState extends State<User_Management> {
  bool _test =false;
  final userdata=GetStorage();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(LocaleKeys.Users.tr(),style: TextStyle(overflow: TextOverflow.ellipsis),),
          centerTitle: true,
          elevation: 0.0,
          bottom: TabBar(
            tabs: [
              Tab(text: LocaleKeys.Requests.tr(), icon: Icon(Icons.message,),),
              Tab(text: LocaleKeys.ActivatedAccounts.tr(),icon: Icon(Icons.people,),),
            ],
          ),
          actions: [
            //CHANGE THE APP'S THEME ICON
            GestureDetector(
              child: Icon( _test==false ? Icons.brightness_3_sharp : Icons.wb_sunny),
              //WE CALL THE THEME SWITCHER METHOD
              onTap: (){ThemeService().switchTheme();
              setState(() {
                _test = !_test;
              });
              ThemeSwitchedAlert(context);
              },

            ),

            //Spacing
            SizedBox(width: 20,),
          ],
        ),

        drawer: MySideBar(),
        body: TabBarView(children: [
          RequestedUsers(),
          AllUsers(),
        ]),
      ),
    );
  }
}