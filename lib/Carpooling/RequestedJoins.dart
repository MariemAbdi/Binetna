import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mae_application/Carpooling/ApprovedRequests.dart';
import 'package:mae_application/Carpooling/Requests.dart';

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../translations/locale_keys.g.dart';

class RequestedJoins extends StatefulWidget {
  late List<String> people;
  late List<String> accepted;
  late String id;

  RequestedJoins({required this.people,required this.accepted,required this.id});

  @override
  State<RequestedJoins> createState() => _RequestedJoinsState();
}

class _RequestedJoinsState extends State<RequestedJoins> {
  int _selectedIndex=0;
  late List<String> people;
  static List<Widget> _pages=[];


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    _pages=<Widget>[
      Requests(people: widget.people, id: widget.id),
      ApprovedRequests(people: widget.accepted,id: widget.id,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      },
      child: Scaffold(
        appBar: MyAppBar(title: _selectedIndex==0?LocaleKeys.Requests.tr():LocaleKeys.accepted.tr(),),
        body: _pages[_selectedIndex],
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
              icon: Icon(Icons.question_mark),
              label: LocaleKeys.Requests.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: LocaleKeys.accepted.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
