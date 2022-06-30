import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Login_Registration/LoginPage.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';


class RegistrationValidation extends StatefulWidget {
  const RegistrationValidation({Key? key}) : super(key: key);

  @override
  State<RegistrationValidation> createState() => _RegistrationValidationState();
}

class _RegistrationValidationState extends State<RegistrationValidation> with SingleTickerProviderStateMixin{

  //AN ANIMATION CONTROLLER
  late AnimationController _controller;

  @override
  void initState(){
    //INITIALISING THE CONTROLLER
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    //A LISTENER TO KNOW WHEN THE ANIMATION IS COMPLETED
    _controller.addStatusListener((status) {
      //IF THE ANIMATION IS COMPLETED WE GO TO THE HOME SCREEN
      if(status == AnimationStatus.completed)
      {Get.to(Login(),transition: Transition.downToUp);
      }
    });

    super.initState();
  }

  @override
  void dispose(){
    //DISPOSING OF THE CONTROLLER
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          body: Container(
            decoration: ForgotPasswordImage(Theme.of(context)),
            child: Center(
              child: Column(
                //THE ITEMS ARE CENTRED ON BOTH AXIS
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //SUCCESSFULLY LOGGED IN TEXT
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(LocaleKeys.Congratulations.tr(),
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40,color: Theme.of(context).primaryColorDark,),),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(LocaleKeys.accountcreated.tr(),
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20,color: Theme.of(context).primaryColor,),),
                  ),

                  SizedBox(height: 50,),//SOME SPACING

                  //HERE GOES THE ASSET, WE SET ITS WIDTH AND CONTROLLER
                  Lottie.asset("assets/lottie/registration-success.json",controller: _controller,width: MediaQuery.of(context).size.width*0.8,
                      //WE GIVE THE ANIMATION'S DETAILS HERE
                      onLoaded: (comp){
                        //THE ANIMATION'S DURATION
                        _controller.duration=comp.duration;
                        //TO START THE ANIMATION
                        _controller.forward();
                      },),],
              ),
            ),
          ),


        ),
      ),
    );
  }

}
