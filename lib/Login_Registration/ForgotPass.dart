import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mae_application/Login_Registration/LoginPage.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Services/Validators.dart';
import 'package:easy_localization/easy_localization.dart';


import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //THE FORM KEY
  final _formKey = GlobalKey<FormState>();
  final MailController = TextEditingController();
  late String Mail;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  void dispose() {
    MailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS
    return GestureDetector(
      onTap: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,size: 30,),
            onPressed: () {
              Get.to(Login());
            },

          ),
        ),
        body:Stack(
          children: [
            //BACKGROUND IMAGE
            Container(
              decoration: ForgotPasswordImage(Theme.of(context)),
            ),

            Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
      child: Container(
      child: Form(
          key: _formKey,
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      //WELCOME BACK MESSAGE & ITS STYLING
      FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(LocaleKeys.forgottitle.tr(),
        style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 40,
        color: MyThemes.darkgreen),
        ),
      ),
      Container(
        width: size.width/1.35,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(LocaleKeys.forgottitle2.tr(),
          style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          color:MyThemes.lightgreen),
          ),
        ),
      ),

      //ANIMATION
   Lottie.asset("assets/lottie/forget-password-animation.json", width: size.width * 0.7, ),


        //E-MAIL FIELD GOES HERE
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
            keyboardType: TextInputType.emailAddress,
            autofillHints: [AutofillHints.email],
            controller: MailController,
            onChanged: (value) {
              setState(() {});
            },
            onSaved: (val) => setState(() {
              Mail = val!.trim();
            }),
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email),
              hintText: LocaleKeys.email.tr(),
              suffixIcon: MailController.text.isEmpty
                  ? null
                  : IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  MailController.clear();
                  setState(() {});
                },
              ),
            ),
          ),
        ),

        SizedBox(height: 20,),

        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            _formKey.currentState!.save();

            bool okay=false;

            //FIELD VALIDATION
            okay=MailValidation(context, Mail);

            if(!okay){
              showDialog(context: context,
                  barrierColor: Theme.of(context).primaryColorDark,
                  barrierDismissible: false,
                  builder: (context)=>Center(
                    child: CircularProgressIndicator(color: MyThemes.darkgreen,),));

              try{
                await FirebaseAuth.instance.sendPasswordResetEmail(email: Mail.toLowerCase());

                EmailSentAlert(context,Mail);
                Get.to(Login());

            } catch(e){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    content: Text(LocaleKeys.somethingwrong.tr())))
                    .closed
                    .then((value) => ScaffoldMessenger.of(context)
                    .clearSnackBars());              Navigator.of(context).pop();
              }
            }
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ButtonColor(Theme.of(context))),
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(LocaleKeys.resetpassword.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
      ),
      ),
      ),
      )
  ),]),
  ),
    );
  }
}
