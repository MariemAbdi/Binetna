import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Profile/ProfilePage.dart';

class SideBarHeaderWidget extends StatefulWidget {
  const SideBarHeaderWidget({Key? key,required this.name, required this.mail, required this.img}) : super(key: key);

  final String name;
  final String mail;
  final Widget img;

  @override
  State<SideBarHeaderWidget> createState() => _SideBarHeaderWidgetState();
}

class _SideBarHeaderWidgetState extends State<SideBarHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ()=> Get.to(Profile(),transition: Transition.downToUp),
        child: Column(
          children: [
            Row(
              children: [
               // CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/NoPhoto.jpg"),),
                //ClipRRect(borderRadius: BorderRadius.circular(40), child: Image.asset("assets/logo.png", fit: BoxFit.cover, width: 100,height: 100,),),
                Container(
                  width: size.width / 5,
                  height: size.width / 5,

            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.transparent),
              shape: BoxShape.circle,
            ),

                  child: widget.img,
                ),
                
                
                SizedBox(width: 10,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(LocaleKeys.MyProfile.tr(),maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18,color: Colors.white))),
                    ],
                  ),
                ),
                //Spacer(),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleKeys.wlcmheader.tr() +widget.name,maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: true,style: TextStyle(fontSize: 18,color: Colors.white)),

                      SizedBox(height: 4,),

                      Text(widget.mail,maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: true,style: TextStyle(fontSize: 15,color: Colors.white),),

                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}