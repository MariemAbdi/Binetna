import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../Services/My_Services.dart';
import '../Services/Theme_Service.dart';
import '../SideBar/SideBar.dart';
import '../translations/locale_keys.g.dart';
import 'ApprovedCertifs.dart';
import 'DeniedCertifs.dart';
import 'UnreadCertifs.dart';

class certif_management extends StatefulWidget {
  const certif_management({Key? key}) : super(key: key);

  @override
  State<certif_management> createState() => _certif_managementState();
}

class _certif_managementState extends State<certif_management> {
  bool _test =false;
  final userdata=GetStorage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(LocaleKeys.Certifications.tr(), style: TextStyle(overflow: TextOverflow.ellipsis),),

          centerTitle: true,

          bottom: TabBar(
            tabs: [
              Tab(text: LocaleKeys.Unread.tr() , icon: Icon(Icons.mark_as_unread, ),),
              Tab(text: LocaleKeys.Approved.tr(),icon: Icon(Icons.approval_rounded,),),
              Tab(text: LocaleKeys.Denied.tr(),icon: Icon(Icons.delete_forever,),),
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
          UnreadCertifs(),
          ApprovedCertifs(),
          DeniedCertifs(),

        ]),
      ),
    );
  }
}
