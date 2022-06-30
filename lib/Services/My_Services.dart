import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Services/MyThemes.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Login_Registration/LoginPage.dart';

BackgroundImage(ThemeData theme){
  if (theme.brightness==MyThemes.lightTheme.brightness)
    {return BoxDecoration(
      image: DecorationImage(
          image:AssetImage("assets/Background/3.png"),
          fit: BoxFit.cover),
    );}
  else if (theme.brightness==MyThemes.darkTheme.brightness){
    return BoxDecoration(image: DecorationImage(
        image:AssetImage("assets/Background/4-1.png"),
          fit: BoxFit.cover)
    );
  }
}

ForgotPasswordImage(ThemeData theme){
  if (theme.brightness==MyThemes.lightTheme.brightness)
  {return BoxDecoration(
    image: DecorationImage(
        image:AssetImage("assets/Background/5.png"),
        fit: BoxFit.cover),
  );}
  else if (theme.brightness==MyThemes.darkTheme.brightness){
    return BoxDecoration(image: DecorationImage(
        image:AssetImage("assets/Background/6-1.png"),
        fit: BoxFit.cover)
    );
  }
}

LoginBackgroundImage(ThemeData theme){
  if (theme.brightness==MyThemes.lightTheme.brightness)
  {return BoxDecoration(
    image: DecorationImage(
        image:AssetImage("assets/Background/1.png"),
        fit: BoxFit.cover),
  );}
  else if (theme.brightness==MyThemes.darkTheme.brightness){
    return BoxDecoration(image: DecorationImage(
        image:AssetImage("assets/Background/2-1.png"),
        fit: BoxFit.cover)
    );
  }
}

NoImage(String gender){
  if(gender.compareTo("Female")==0)
  return AssetImage("assets/FemaleAvatar.png");
  else return AssetImage("assets/MaleAvatar.png");
}

ErrorColor(ThemeData theme){
  if(theme.brightness==MyThemes.lightTheme.brightness){
    return Colors.black;

  }else{
    return Colors.white;
  }
}

FieldColor(ThemeData theme){
  if(theme.brightness==MyThemes.lightTheme.brightness){
    return theme.primaryColorDark;

  }else{
    return theme.primaryColorLight;
  }
}

Tiles(ThemeData theme){
  if(theme.brightness==MyThemes.lightTheme.brightness) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }else{return BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withOpacity(0.5)),
    color: MyThemes.darkTheme.primaryColorLight,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 3,
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ],
  );}
}

ButtonColor(ThemeData theme){
  if(theme.brightness==MyThemes.lightTheme.brightness){
    return MyThemes.darkgreen;

  }else{
    return Colors.grey.shade900;
  }
}

Future QuitAppAlert(BuildContext context,){
  return CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: LocaleKeys.QuitApp.tr(),
      text: LocaleKeys.quitappquestion.tr(),
      loopAnimation: true,
      lottieAsset: "assets/lottie/QuitApp.json",
      backgroundColor: Theme.of(context).primaryColorDark,
      cancelBtnText: LocaleKeys.CANCELAlert.tr(),
      confirmBtnColor: Theme.of(context).primaryColorDark,
      confirmBtnText: LocaleKeys.LEAVE.tr(),
      onCancelBtnTap: (){Get.back();},
      onConfirmBtnTap: (){
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');},);
}

Future LanguageChoice(BuildContext context,String lang){
  String text="English";
  if(lang.compareTo("Français")==0){
    text="Français";
  }
  return CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      title: lang.compareTo("Français")==0?"Langue":"Language",
      text: text,
      loopAnimation: true,
      lottieAsset: "assets/lottie/translate-language.json",
      backgroundColor: Theme.of(context).primaryColorDark,

      confirmBtnColor: Theme.of(context).primaryColorDark,
      confirmBtnText: "OKAY",);
}

Future LogOutAlert(BuildContext context,){
  final userdata=GetStorage();
  return CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: LocaleKeys.LOGOUT.tr(),
      text: LocaleKeys.LogoutQuestion.tr(),
      loopAnimation: true,
      lottieAsset: "assets/lottie/LogOut.json",
      backgroundColor: Theme.of(context).primaryColorDark,
      cancelBtnText: LocaleKeys.CANCELAlert.tr(),
      confirmBtnColor: Theme.of(context).primaryColorDark,
      confirmBtnText: LocaleKeys.yes.tr(),
      confirmBtnTextStyle: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white),
      onCancelBtnTap: (){Get.back();},
      onConfirmBtnTap:() async {
          //REMOVE SHARED PREFERENCES
          if(userdata.read('isLogged')!=false)
          {userdata.write('isLogged',false);}

          if(userdata.read('mail')!=null)
          {userdata.remove('mail');}

          if(userdata.read('role')!=null)
          {userdata.remove('role');}


          await FirebaseAuth.instance.signOut();

          //GO BACK TO THE LOGIN SCREEN
          Get.to(Login(),transition: Transition.zoom);
        });
}

Future ThemeSwitchedAlert(BuildContext context,){
  var theme="Dark Theme";
  if(Theme.of(context).brightness==Brightness.dark){
    theme="Light Theme";
  }
  return CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      title: LocaleKeys.ThemeSwitch.tr(),
      width: MediaQuery.of(context).size.width,
      text: theme+LocaleKeys.activated.tr(),
      loopAnimation: true,
      lottieAsset: "assets/lottie/night-day.json",
      backgroundColor: Theme.of(context).primaryColorDark,
      confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future WaitForActivationAlert(BuildContext context,){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.info,
    title: LocaleKeys.AccountActivation.tr(),
    text: LocaleKeys.accountactivationalert.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/wait-for-activation.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future EmailSentAlert(BuildContext context,String mail){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.info,
    title: LocaleKeys.resetpassword.tr(),
    text: LocaleKeys.mailsent.tr() +mail,
    loopAnimation: true,
    lottieAsset: "assets/lottie/mail-sent.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future UpdateSuccessAlert(BuildContext context){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.info,
    title: LocaleKeys.update.tr(),
    text: LocaleKeys.updatetext.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/uploadingdata.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future SentSuccessfullyAlert(BuildContext context, String what){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.info,
    title: "Information",
    text: what+LocaleKeys.sentsuccessfully.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/loading-data.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future AddedSuccessfullyAlert(BuildContext context, String what){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.info,
    title: "Information",
    text: what+LocaleKeys.addedsuccessfully.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/AddesSuccessfully.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future ThisCodeExistsAlert(BuildContext context){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.warning,
    title: "Information",
    text: LocaleKeys.codeexists.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/codeexists.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future CantEditCertifAlert(BuildContext context){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.warning,
    title: "Information",
    text: LocaleKeys.cantedit.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/CantEdit.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

Future ThisMailExistsAlert(BuildContext context){
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.warning,
    title: "Information",
    text: LocaleKeys.mailexists.tr(),
    loopAnimation: true,
    lottieAsset: "assets/lottie/mailexists.json",
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
  );
}

class UpperCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: Capitalize(newValue.text),
      selection: newValue.selection,
    );
  }}
String Capitalize(String value){
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

String myDestinations(List<String> destinations) {
  String mydests="";
  for(int i=0;i<destinations.length;i++){
    mydests+=destinations[i]+',';
  }
  return mydests;
}

