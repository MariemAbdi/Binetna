import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Login_Registration/RegistrationForm.dart';
import 'package:mae_application/Services/My_Services.dart';
import 'package:mae_application/Services/Validators.dart';

import '../Profile/User.dart';
import '../Services/MyThemes.dart';
import '../Services/Theme_Service.dart';
import '../translations/locale_keys.g.dart';
import 'ForgotPass.dart';
import 'SuccessfulLogin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {

  //FOR THE LOGIN _ REGISTRATION ANIMATION : THE CONTAINER
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);

  //THE FORMS KEYS
  final LogformKey = GlobalKey<FormState>();

  //LIST OF CONTROLLERS : LOGIN FORM
  final LogMailController = TextEditingController();
  final passwordController = TextEditingController();


  //PASSWORD'S VISIBILITY : LOGIN
  bool _isVisible = false;

  //REMEMBER ME CHECKBOX
  bool isChecked = false;
  final mydata=GetStorage();

  //FORM FIELDS
  late String LogPass;
  late String LogMail;

  bool connected=false;

  internetconnection()async{
    var connectivity = await (Connectivity().checkConnectivity());
    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi){
      setState(() {
        connected=true;
      });
    }else{
      setState(() {
        connected=false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          content:
          Text(LocaleKeys.internet.tr())))
          .closed
          .then((value) => ScaffoldMessenger.of(context)
          .clearSnackBars());
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: animationDuration);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

    internetconnection();
  }

  @override
  void dispose() {
    animationController.dispose();
    LogMailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS
    double viewInset = MediaQuery.of(context).viewInsets.bottom; //TO KNOW WHEN THE KEYBOARD POPS UP
    double defaultLoginHeight = size.height - (size.height * 0.2); //GETTING THE DEFAULT HEIGHT FOR LOGIN
    double defaultRegistrationHeight = size.height - (size.height * 0.1); //GETTING THE DEFAULT HEIGHT FOR REGISTRATION (SMALLER THAN LOGIN)
    //Container's initial size : when it's not clicked yet and then the form's height
    containerSize =
        Tween<double>(begin: size.height * 0.1 , end: defaultRegistrationHeight)
            .animate(CurvedAnimation(parent: animationController, curve: Curves.linear)); //SETTING THE REGISTRATION FORM'S CONTAINER SIZE

    //THE REMEMBER ME CHECKBOX PALETTE
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.selected,
        MaterialState.hovered,
        MaterialState.focused,
        MaterialState.pressed,
      };
      if (states.any(interactiveStates.contains)) {
        return MyThemes.darkgreen;
      }
      return Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey;
    }

    //OUR PAGE
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
            body: Stack(
            children: [
            //BACKGROUND IMAGE
            Container(
              decoration: LoginBackgroundImage(Theme.of(context))
            ),

            Positioned(
              top: 10,
              right: 10,
              child:  //CHANGE THE APP'S THEME ICON
              GestureDetector(
                child: Icon( Theme.of(context).brightness==MyThemes.lightTheme.brightness ? Icons.brightness_3_sharp : Icons.wb_sunny,
                size: 30,
                ),
                //WE CALL THE THEME SWITCHER METHOD
                onTap: (){
                  ThemeService().switchTheme();

                  ThemeSwitchedAlert(context);
                },

              ),
            ),

            //CANCEL BUTTON
            AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: size.width,
                  height: size.height * 0.1,
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).brightness==MyThemes.lightTheme.brightness? Colors.black:Colors.white,),
                    onPressed: isLogin
                        ? null
                        : () {
                            //returning null to disable the button
                            animationController.reverse();
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                  ),
                ),
              ),
            ),

            //THE LOGIN FORM
            AnimatedOpacity(
              opacity: isLogin ? 1.0 : 0.0,
              duration: animationDuration * 4,
              child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      height: defaultLoginHeight,
                      child: Form(
                        key: LogformKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //WELCOME BACK MESSAGE & ITS STYLING
                            Container(
                              width: size.width/1.1,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(LocaleKeys.wlcmback.tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 40,
                                      color: MyThemes.darkgreen),
                                ),
                              ),
                            ),
                            Text(LocaleKeys.umissed.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  color: MyThemes.lightgreen),
                            ),

                            SizedBox(height: 20,),
                            //LOGO GOES HERE
                            Container(
                              height: 200,
                              width: 200,
                              child: Image.asset(
                                "assets/logo-only.png",
                              ),


                            ),
                            SizedBox(height: 20,),

                            //E-MAIL FIELD GOES HERE
                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                autofillHints: [AutofillHints.email],
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                controller: LogMailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: LocaleKeys.email.tr(),
                                  suffixIcon: LogMailController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            LogMailController.clear();
                                            setState(() {});
                                          },
                                        ),
                                ),
                                onSaved: (val) => setState(() {
                                  LogMail = val!.trim().toLowerCase();
                                }),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //PASSWORD FIELD GOES HERE
                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                controller: passwordController,
                                obscureText: !_isVisible,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.vpn_key_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    icon: _isVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  ),
                                  hintText: LocaleKeys.pass_word.tr(),
                                ),
                                onSaved: (val) => setState(() {
                                  LogPass = val!;
                                }),
                              ),
                            ),

                            //REMEMBER ME CHECKBOX AND FORGOT PASSWORD ROW
                            Container(
                              width: size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            FocusScope.of(context).unfocus();

                                            isChecked = value!;
                                          });
                                        },
                                      ),
                                      Container(
                                        width: size.width * 0.25,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(LocaleKeys.RememberMe.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: size.width * 0.1,),
                                  //FORGOT YOUR PASSWORD LINK
                                  GestureDetector(
                                    child: Container(
                                      width: size.width * 0.25,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(LocaleKeys.forgotpassword.tr(),
                                          maxLines: 3,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();

                                      //GO TO THE FORGOT PASSWORD PAGE
                                      Get.to(ForgotPassword());
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ), //SOME SPACING

                            //LOGIN BUTTON
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                LogformKey.currentState!.save();

                                bool test = false;

                                //FIELD VALIDATION
                                test=LoginValidator(context,LogMail,LogPass);


                                internetconnection();

                                if (!test && connected) {
                                  //IF EVERYTHING IS OKAY WE GO TO THE SUCCESS PAGE
                                  if(isChecked){mydata.write('isLogged', true);}


                                  //SAVE THE MAIL AS SHARED PREFERENCES
                                  mydata.write('mail', LogMail);



                                  final snap = await FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: LogMail).get();

                                  if(snap.docs.length==0){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(LocaleKeys.PleaseCheckYourCredentials.tr())))
                                        .closed
                                        .then((value) => ScaffoldMessenger.of(context)
                                        .clearSnackBars());
                                  }

                                  //SAVE THE CODE FOR FUTURE USES
                                  //CHECK FOR ROLE
                                  //CHECK IF ACCOUNT IS ACTIVATED
                                  FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: LogMail).get().then((value) =>
                                      value.docs.forEach((element) async {
                                        mydata.write("code",element['code']);

                                        //CHECK FOR ROLE IF IT EXISTS
                                        HasRole(element['code']);

                                          FirebaseMessaging.instance.subscribeToTopic("notifications");
                                        FirebaseMessaging.instance.subscribeToTopic("carpooling");


                                        //CHECK IF ACCOUNT IS ACTIVATED
                                        if(element['activated']==true)
                                        { //GO TO THE LOGIN SUCCESS PAGE
                                          try{
                                            //CHECK IF USER EXISTS IN THE AUTHENTICATION PAGE
                                            await FirebaseAuth.instance.signInWithEmailAndPassword(email: LogMail, password: LogPass);
                                            Get.to(LoginValidation(),transition: Transition.rightToLeft);

                                          }on FirebaseAuthException catch(e){
                                            if(e.code=='user-not-found'){
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content:
                                                  Text(LocaleKeys.Nouserfoundwithsuchcredentials.tr())))
                                                  .closed
                                                  .then((value) => ScaffoldMessenger.of(context)
                                                  .clearSnackBars());
                                            }else if(e.code=='wrong-password'){
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content:
                                                  Text(LocaleKeys.PleaseVerifyYourPassword.tr())))
                                                  .closed
                                                  .then((value) => ScaffoldMessenger.of(context)
                                                  .clearSnackBars());
                                            }
                                          }catch (e){
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(LocaleKeys.somethingwrong.tr())))
                                                .closed
                                                .then((value) => ScaffoldMessenger.of(context)
                                                .clearSnackBars());
                                          }
                                        }
                                        else{//Wait For A Confirmation Mail Message
                                          WaitForActivationAlert(context);
                                        }
                                      }));
                                }

                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ButtonColor(Theme.of(context)),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 20),
                                alignment: Alignment.center,
                                child: Text(LocaleKeys.login.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )









                          ],
                        ),
                      ),
                    ),
                  )),
            ),

            //THE REGISTRATION FORM CONTAINER
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                if (viewInset == 0 && isLogin) {
                  return buildRegistration();
                } else if (!isLogin) {
                  return buildRegistration();
                }
                //Returning empty container to hide the widget in case a keyboard is started
                return Container();
              },
            ),

            //THE REGISTARTION FORM
            RegisterForm(isLogin: isLogin, animationDuration: animationDuration, size: size, defaultLoginHeight: defaultLoginHeight)

        ],
        )),
      ),
    );
  }

  //REGISTRATION CONTAINER WIDGET
  Widget buildRegistration() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color: Colors.grey.shade700,
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? Container(
            width: MediaQuery.of(context).size.width/1.25,
                child: FittedBox(
            fit: BoxFit.scaleDown,
                  child: Text(LocaleKeys.signup.tr(),
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
                    ),
                ),
              )
              : null,
        ),
      ),
    );
  }
}

//THE CIRCULAR SHAPE FOR THE REGISTRATION FORM
class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
