import 'package:flutter/material.dart';
import 'package:mae_application/Services/My_Services.dart';

import '../Services/MyThemes.dart';
import '../Services/Theme_Service.dart';


class MyAppBar extends StatefulWidget with PreferredSizeWidget{
  final String title;

  const MyAppBar({Key? key,required this.title}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);

}

class _MyAppBarState extends State<MyAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(widget.title, style: TextStyle(overflow: TextOverflow.ellipsis),
        textDirection: widget.title.contains(RegExp("[a-zA-Z]"))?TextDirection.ltr:TextDirection.rtl,
      ),

      centerTitle: true,
      actions: [
        //CHANGE THE APP'S THEME ICON
        GestureDetector(
            child: Icon( Theme.of(context).brightness==MyThemes.lightTheme.brightness ? Icons.brightness_3_sharp : Icons.wb_sunny),
          //WE CALL THE THEME SWITCHER METHOD
          onTap: (){
          ThemeService().switchTheme();

          ThemeSwitchedAlert(context);
          },

        ),

        //Spacing
        SizedBox(width: 20,),
      ],
    );
  }
}
