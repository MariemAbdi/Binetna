import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

bool dropDownVerification(String drop,String text,String msg, BuildContext context){
  bool test=false;
  if (drop.compareTo(text)==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(msg)))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }
  return test;
}

bool CertifDateVerification(BuildContext context, DateTime starting, DateTime ending){
  bool test=false;

  if (starting.difference(DateTime.now()).inDays<0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.validstartingdate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (ending.difference(starting).inDays<1) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.validendingdate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool CodeValidation(BuildContext context, String code){
  bool test=false;

  if (code.isEmpty) {
    test = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.emptymail.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
  } else if (code.length != 3) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.code4.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!code.isNumericOnly) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.codenumeric.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool MailValidation(BuildContext context, String email){
  bool test=false;
  if (email.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.emptymail.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    ScaffoldMessenger.of(context)
      ..showSnackBar(SnackBar(
          content:
          Text(LocaleKeys.validMail.tr())))
          .closed
          .then((value) => ScaffoldMessenger.of(context)
          .clearSnackBars());
    test = true;
  }
  return test;
}

bool FirstValidation(BuildContext context, String first){
  bool test=false;

  if (first.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptyfirst.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!RegExp(r'^[a-z A-Z]+$')
      .hasMatch(first)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.unvalidfirst.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool LastValidation(BuildContext context, String last){
  bool test=false;

  if (last.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptylast.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!RegExp(r'^[a-z A-Z]+$')
      .hasMatch(last)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.unvalidlast.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool EighteenyearsValidation(BuildContext context, DateTime date){
  bool test=false;
  if (DateTime.now().difference(date).inDays<6574.5) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.eighteenYrs.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool PhoneValidation(BuildContext context, String phone){
  bool test=false;
  if (phone.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptyphone.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if ((phone.length != 8) || (!phone.isNumericOnly)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.unvalidphone.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool PasswordValidation(BuildContext context, String password){
  bool test=false;

  if (password.isEmpty) {
    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
  content: Text(
      LocaleKeys.emptypassword.tr()))).closed
      .then((value) => ScaffoldMessenger.of(context)
      .clearSnackBars());
    test = true;
  }
  else if (password.length <6) {
    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
  content: Text(LocaleKeys.password6.tr())))
      .closed
      .then((value) => ScaffoldMessenger.of(context)
      .clearSnackBars());
    test = true;
  }

  return test;
}

bool ImageValidation(BuildContext context,XFile? _image){
  bool test=false;
  if(_image==null){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptypic.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test=true;
  }

  return test;
}

bool isEmptyValidation(BuildContext context, String field, String msg){
  bool test=false;
  if (field.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(msg)))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}


bool Profile_Update_Validator(BuildContext context,String email,String first,String last,String gender,
    String address,DateTime birthdate,String phone,String department,String password){
  bool test=false;
  if (email.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.emptymail.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    ScaffoldMessenger.of(context)
      ..showSnackBar(SnackBar(
          content:
          Text(LocaleKeys.validMail.tr())))
          .closed
          .then((value) => ScaffoldMessenger.of(context)
          .clearSnackBars());
    test = true;
  }else if (first.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptyfirst.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (!RegExp(r'^[a-z A-Z]+$')
      .hasMatch(first)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.unvalidfirst.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else  if (last.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptylast.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (!RegExp(r'^[a-z A-Z]+$')
      .hasMatch(last)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.unvalidlast.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (gender.compareTo(LocaleKeys.Gender.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PleaseSelectAGender.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if (address.compareTo(LocaleKeys.Address.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PleaseSelectAnAddress.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if (DateTime.now().difference(birthdate).inDays<6574.5) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.eighteenYrs.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (phone.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptyphone.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if ((phone.length != 8) || (!phone.isNumericOnly)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.unvalidphone.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (department.compareTo(LocaleKeys.Department.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PleaseSelectADepartment.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if (password.isNotEmpty && password.length <6) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.password6.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool MyCertif_Add_Validator(BuildContext context, String reason,DateTime starting,DateTime ending,XFile? _image,String other){
  bool test=false;
  if (reason.compareTo(LocaleKeys.Reason.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.selectreason.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if(reason.compareTo(LocaleKeys.Other.tr())==0 && other.isEmpty){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text("Please Select A Reason")))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else  if (starting.difference(DateTime.now()).inDays<0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.validstartingdate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (ending.difference(starting).inDays<0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.validendingdate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if(_image==null){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptypic.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test=true;
  }
  return test;
}

bool MyCertif_Edit_Validator(BuildContext context, String reason,DateTime starting,DateTime ending,String other){
  bool test=false;
  if (reason.compareTo(LocaleKeys.Reason.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.selectreason.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if(reason.compareTo(LocaleKeys.Other.tr())==0 && other.isEmpty){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text("Please Select A Reason")))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else  if (starting.difference(DateTime.now()).inDays<0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.validstartingdate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (ending.difference(starting).inDays<0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.validendingdate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool Post_Add_Edit_Validator(BuildContext context,String title,String description,String category,XFile? _image){
  bool test=false;
  if (title.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptytitle.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (description.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptydescription.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (category.compareTo(LocaleKeys.Category.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptycategory.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if(_image==null){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptypic.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test=true;
  }
  return test;

}

bool Post_Edit_Validator(BuildContext context,String title,String description,String category){
  bool test=false;
  if (title.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptytitle.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (description.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptydescription.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (category.compareTo(LocaleKeys.Category.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptycategory.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }
  return test;

}

bool RegisterValidator(BuildContext context,String code,String email,String first,String last,String gender,
    String address,DateTime birthdate,String phone,String department,String password){
  bool test=false;
  if (code.isEmpty) {
    test = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.emptycode.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
  }else if (code.length != 3) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.code4.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (!code.isNumericOnly) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.codenumeric.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (email.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.emptymail.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    ScaffoldMessenger.of(context)
      ..showSnackBar(SnackBar(
          content:
          Text(LocaleKeys.validMail.tr())))
          .closed
          .then((value) => ScaffoldMessenger.of(context)
          .clearSnackBars());
    test = true;
  }else if (first.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptyfirst.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (!RegExp(r'^[a-z A-Z]+$')
      .hasMatch(first)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.unvalidfirst.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else  if (last.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptylast.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (!RegExp(r'^[a-z A-Z]+$')
      .hasMatch(last)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.unvalidlast.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (gender.compareTo(LocaleKeys.Gender.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PleaseSelectAGender.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if (address.compareTo(LocaleKeys.Address.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PleaseSelectAnAddress.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if (DateTime.now().difference(birthdate).inDays<6574.5) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.eighteenYrs.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (phone.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.emptyphone.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if ((phone.length != 8) || (!phone.isNumericOnly)) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
  content: Text(
      LocaleKeys.unvalidphone.tr()))).closed
      .then((value) => ScaffoldMessenger.of(context)
      .clearSnackBars());
  test = true;
  }else if (department.compareTo(LocaleKeys.Department.tr())==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PleaseSelectADepartment.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }else if (password.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.emptypassword.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  else if (password.length <6) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.password6.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool LoginValidator(BuildContext context,String email,String password){
  bool test=false;
  if (email.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.emptymail.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  } else if (!RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    ScaffoldMessenger.of(context)
      ..showSnackBar(SnackBar(
          content:
          Text(LocaleKeys.validMail.tr())))
          .closed
          .then((value) => ScaffoldMessenger.of(context)
          .clearSnackBars());
    test = true;
  }else if (password.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            LocaleKeys.emptypassword.tr()))).closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  else if (password.length <6) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(LocaleKeys.password6.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }
  return test;
}

bool CarpoolingAdd_Update(BuildContext context, String places, List<String>? destinations, DateTime day_time){
  bool test=false;
  if (day_time.difference(DateTime.now()).inDays<0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.ValidDate.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }else if (destinations!.length==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.EmptyDestination.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test = true;
  }if (places.compareTo("Places")==0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content:
        Text(LocaleKeys.PlacesNumber.tr())))
        .closed
        .then((value) => ScaffoldMessenger.of(context)
        .clearSnackBars());
    test= true;
  }
  return test;
}

/***********************************************************************************************/
bool Validation(BuildContext context){
  bool test=false;

  return test;
}