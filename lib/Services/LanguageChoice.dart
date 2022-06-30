import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../Login_Registration/LoginPage.dart';
import '../translations/locale_keys.g.dart';
import 'MyThemes.dart';
import 'My_Services.dart';

class Lang_Choice extends StatefulWidget {
  const Lang_Choice({Key? key}) : super(key: key);

  @override
  State<Lang_Choice> createState() => _Lang_ChoiceState();
}

bool selected=false;
final language = GetStorage();


class _Lang_ChoiceState extends State<Lang_Choice> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      },
      child: IntroductionScreen(
       done: FittedBox(fit:BoxFit.fitWidth,child: Text(LocaleKeys.login.tr(), style: TextStyle(color: MyThemes.darkgreen, fontWeight: FontWeight.w800),)),
       onDone: (){
         language.write('onboarding', true);
         Get.to(Login());
       },
       globalBackgroundColor: Colors.white,
       next: Icon(Icons.arrow_forward, color: MyThemes.darkgreen,),
        showDoneButton: selected,
        dotsDecorator: DotsDecorator(
         activeColor: MyThemes.lightgreen,
         color: MyThemes.darkgreen,
         size: Size(15,15),
         activeSize: Size(22,15),
         activeShape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(24)
         )
       ),
       pages: [

         //PAGE1
         PageViewModel(
           image:  Center(child: Image.asset("assets/logo-only.png",width: MediaQuery.of(context).size.width *0.6,)),
           decoration: PageDecoration(
             titleTextStyle: TextStyle(fontWeight: FontWeight.w800,color: MyThemes.darkgreen, fontSize: 30),
             bodyTextStyle: TextStyle(fontWeight: FontWeight.w800,color: MyThemes.lightgreen, fontSize: 30),

               boxDecoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Background/on-boarding-bg.png"),
                ),
              ),

             titlePadding: EdgeInsets.all(8.0),
             bodyPadding: EdgeInsets.all(16),
             imagePadding: EdgeInsets.all(16.0),


           ),

           titleWidget: FittedBox(fit: BoxFit.fitWidth,
             child: Text("Welcome To Binetna!", style: TextStyle(color: MyThemes.darkgreen, fontSize: 30, fontWeight: FontWeight.w800),),),
           bodyWidget: FittedBox(fit: BoxFit.fitWidth,
           child: Text("Soyez Le Bienvenue À Binetna!", style: TextStyle(color: MyThemes.lightgreen, fontSize: 30, fontWeight: FontWeight.w800),),),
         ),

         //PAGE 2
         PageViewModel(
           image: Center(child: Lottie.asset("assets/lottie/on-boarding-girl.json",width: MediaQuery.of(context).size.width,)),
           decoration: PageDecoration(
             titleTextStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.w800),
             titlePadding: EdgeInsets.all(10),
             bodyPadding: EdgeInsets.all(10),
             imagePadding: EdgeInsets.all(16),
             boxDecoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage("assets/Background/on-boarding-bg.png"),
               ),
             ),

           ),
           titleWidget: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               FittedBox(
                   fit:BoxFit.fitWidth,
                   child: Text("Please Choose A Language", style: TextStyle(color: MyThemes.darkgreen, fontSize: 30, fontWeight: FontWeight.w800),)),
               SizedBox(height: 30,),
               FittedBox(
                   fit: BoxFit.fitWidth,
                   child: Text("Veuillez Choisir Une Langue",style: TextStyle(color: MyThemes.lightgreen, fontSize: 30, fontWeight: FontWeight.w800))),
             ],
           ),
           bodyWidget: Column(
             mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
      InkWell(
        onTap: () async{
          final _newLocale = Locale('en',);
          await context.setLocale(_newLocale); // change `easy_localization` locale
          Get.updateLocale(_newLocale);

          LanguageChoice(context,"English");
          setState(() {
              selected=true;
                });
          },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          margin: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
              color: MyThemes.darkgreen
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text("English",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        )
      ),
      SizedBox(height: 20,),
      InkWell(
        onTap: () async{

          final _newLocale = Locale('fr',);
          await context.setLocale(_newLocale); // change `easy_localization` locale
          Get.updateLocale(_newLocale);

          LanguageChoice(context,"Français");


          setState(() {
            selected=true;
          });      },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: MyThemes.lightgreen
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text("Français",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        ),
      )

  ],
),

         ),
       ],
   ),
    );
  }
}