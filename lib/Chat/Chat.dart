import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mae_application/Appbar/Header.dart';
import 'package:mae_application/Chat/Conversations.dart';
import 'package:mae_application/Chat/ListOfUsers.dart';
import 'package:mae_application/Services/MyThemes.dart';
import 'package:mae_application/SideBar/SideBar.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  int _selectedIndex=0;
  static List<Widget> pages=<Widget>[
    Conversations(),
    ListOfUsers(),
  ];

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
        appBar: MyAppBar(title: _selectedIndex==0?'Chat':LocaleKeys.Users.tr(),),
        drawer: MySideBar(),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,

          onTap: (index){
            setState(() {
              _selectedIndex=index;

            });
          },
          selectedItemColor: MyThemes.darkgreen,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: LocaleKeys.Messages.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: LocaleKeys.Users.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
