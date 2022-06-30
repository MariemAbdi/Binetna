import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Services/Validators.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Profile/User.dart';
import '../Services/My_Services.dart';
import 'SuccessfulRegistration.dart';
import '../translations/locale_keys.g.dart';


class RegisterForm extends StatefulWidget {
  RegisterForm({required this.isLogin, required this.animationDuration,
  required this.size, required this.defaultLoginHeight});

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginHeight;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  //FORM KEY
  final RegformKey = GlobalKey<FormState>();

  //LIST OF CONTROLLERS/FOCUS NODES : REGISTRATION FORM
  final RegMailController = TextEditingController();
  final RegMailFocus = FocusNode();
  final RegCodeController = TextEditingController();
  final RegPassController = TextEditingController();
  final RegPassFocus = FocusNode();
  final RegFirstController = TextEditingController();
  final RegLastController = TextEditingController();
  final RegPhoneController = TextEditingController();

  //GENDER DROPDOWN
  static List<String> gender=[];
  int position=0;
  static List<String> genderEN = [
    "Gender",
    "Female",
    "Male",];
  static List<String> genderFR = [
    "Sexe",
    "Féminin",
    "Masculin",];

  //DEPARTMENT DROPDOWN
  int pos=0;
  static List<String> dept=[];
  static List<String> deptEN = [
    "Department",
    "Accounting & Finance",
    "Customer Service",
    "Distribution",
    "Human Resources",
    "Information Technology",
    "Marketing",
    "Sales",
    "Search & Development",
  ];
  static List<String> deptFR = [
    "Département",
    "Commercial",
    "Comptabilité & Finance",
    "Distribution",
    "Informatique",
    "Recherche & Développement",
    "Ressources Humaines",
    "Service Client",
    "Vente",
  ];


  //STATE DROPDOWN : ADDRESS
  int index=0;
  static List<String> stat=[];
  static List<String> statEN = [
    "Address",
    "Ariana",
    "Beja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Kef",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];

  static List<String> statFR = [
    "Address",
    "Ariana",
    "Beja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Kef",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];

  //FIELDS' INPUTS
  late String RegCode;
  late String RegMail;
  late String RegFirst;
  late String RegLast;
  late String RegPhone;
  late String RegPass;

  //BIRTHDATE INITIAL VALUE
  DateTime dateTime = DateTime.now();

  //PASSWORD'S VISIBILITY : REGISTARTION
  bool _isVisible1 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?stat.addAll(statEN):stat.addAll(statFR);
    context.locale == Locale('en')?dept=List.from(deptEN):dept=List.from(deptFR);
    context.locale == Locale('en')?gender=List.from(genderEN):gender=List.from(genderFR);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    RegMailController.dispose();
    RegCodeController.dispose();
    RegPassController.dispose();
    RegFirstController.dispose();
    RegLastController.dispose();
    RegPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: widget.size.width,
            height: widget.defaultLoginHeight,
            child: SingleChildScrollView(
              child: Form(
                key: RegformKey,
                child: Column(
                  //AXIS ALIGNMENT
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.registerwlcm.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18,
                      color: Colors.white),
                    ),

                    //SOME SPACING
                    SizedBox(
                      height: 20,
                    ),

                    //REGISTRATION CODE FIELD
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                        controller: RegCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(CupertinoIcons.number,),
                          hintText: LocaleKeys.RegistrationCode.tr(),
                          border: InputBorder.none,
                          suffixIcon: RegCodeController.text.isEmpty
                              ? null
                              : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              RegCodeController.clear();
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            },
                          ),
                        ),
                        onSaved: (val) => setState(() {
                          RegCode= val!;
                        }),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),

                    //SOME SPACING
                    SizedBox(
                      height: 10,
                    ),

                    //E-MAIL FIELD GOES HERE
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        controller: RegMailController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSaved: (val) => setState(() {
                          RegMail = val!.trim().toLowerCase();
                        }),
                        decoration: InputDecoration(
                          icon: Icon(Icons.alternate_email),
                          hintText: LocaleKeys.email.tr(),
                          suffixIcon: RegMailController.text.isEmpty
                              ? null
                              : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              RegMailController.clear();
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ), //SOME SPACING

                    //FIRST NAME FIELD
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextFormField(
                        inputFormatters: [UpperCaseTextFormatter()],
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                        controller: RegFirstController,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          icon: Icon(Icons.assignment_ind_outlined),
                          hintText: LocaleKeys.FirstName.tr(),
                          border: InputBorder.none,
                          suffixIcon: RegFirstController.text.isEmpty
                              ? null
                              : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              RegFirstController.clear();
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSaved: (val) => setState(() {
                          RegFirst = val!;
                        }),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ), //SOME SPACING

                    //LAST NAME FIELD
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextFormField(
                        inputFormatters: [UpperCaseTextFormatter()],
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                        controller: RegLastController,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          icon: Icon(Icons.badge_outlined),
                          hintText: LocaleKeys.LastName.tr(),
                          border: InputBorder.none,
                          suffixIcon: RegLastController.text.isEmpty
                              ? null
                              : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              RegLastController.clear();
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSaved: (val) => setState(() {
                          RegLast = val!;
                        }),
                      ),
                    ),

                    //SOME SPACE
                    SizedBox(
                      height: 10,
                    ), //SOME SP

                    //GENDER
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.face),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                          hintText: gender[position],
                          hintStyle: TextStyle(color: position==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                          border: InputBorder.none,),
                        onChanged: (value) {
                          setState(() {
                          });},

                        onTap: (){
                          showCupertinoModalPopup(context: context,
                              builder: (context)=>SizedBox(
                                height: 180,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 50,
                                  onSelectedItemChanged: (index){setState(() {
                                    this.position=index;
                                  });},
                                  looping: true,
                                  children: [
                                    for (String name in gender) Text( name ),
                                  ],
                                ),

                              ));},),),

                    SizedBox(
                      height: 10,
                    ),

                    //ADDRESS
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.map_outlined),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                          hintText: stat[index],//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                          hintStyle: TextStyle(color: index==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                          border: InputBorder.none,),
                        onChanged: (value) {
                          setState(() {
                          });},

                        onTap: (){
                          showCupertinoModalPopup(context: context,
                              builder: (context)=>SizedBox(
                                height: 180,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 50,
                                  onSelectedItemChanged: (index){setState(() {
                                    this.index=index;
                                  });},
                                  looping: true,
                                  children: [
                                    for (String name in stat) Text( name ),
                                  ],
                                ),

                              ));},),),

                    //SOME SPACE
                    SizedBox(
                      height: 10,
                    ), //SOME SPACING


                    //BIRTHDATE
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,),

                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                          hintText: dateTime.difference(DateTime.now()).inDays ==0 ? LocaleKeys.Birthdate.tr() : DateFormat('dd/MM/yyyy').format(dateTime),
                          hintStyle: TextStyle(color: dateTime.difference(DateTime.now()).inDays ==0 ?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                          border: InputBorder.none,),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onTap: (){showCupertinoModalPopup(context: context,
                            builder: (context)=>CupertinoActionSheet(
                              actions: [
                                SizedBox(height: 180,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date, initialDateTime: dateTime,
                                    maximumYear: DateTime.now().year,
                                    minimumYear: 1900,
                                    onDateTimeChanged: (dateTime){
                                      setState(() {
                                        this.dateTime=dateTime;
                                      });

                                    },
                                  ),),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                  child: Text(LocaleKeys.DONE.tr(),),
                                  onPressed: (){Navigator.pop(context);}
                              ),
                            )
                        );
                        },),),


                    SizedBox(
                      height: 10,
                    ), //SOME SPACING

                    //PHONE NUMBER FIELD
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                        controller: RegPhoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone_android_rounded),
                          hintText: LocaleKeys.PhoneNumber.tr(),
                          border: InputBorder.none,suffixIcon: RegPhoneController.text.isEmpty
                            ? null
                            : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            RegPhoneController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        ),),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSaved: (val) => setState(() {
                          RegPhone = val!;
                        }),),
                    ),

                    //SOME SPACING
                    SizedBox(
                      height: 10,
                    ),

                    //DEPARTMENT LIST
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.work),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                          hintText: dept[pos],
                          hintStyle: TextStyle(color: pos==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                          border: InputBorder.none,),
                        onChanged: (value) {
                          setState(() {
                          });},

                        onTap: (){
                          showCupertinoModalPopup(context: context,
                              builder: (context)=>SizedBox(
                                height: 180,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 50,
                                  onSelectedItemChanged: (index){setState(() {
                                    this.pos=index;
                                  });},
                                  looping: true,
                                  children: [
                                    for (String name in dept) Text( name ),
                                  ],
                                ),
                              ));},),),

                    //SOME SPACING
                    SizedBox(
                      height: 10,
                    ),

                    //PASSWORD FIELD GOES HERE
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: widget.size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                        controller: RegPassController,
                        focusNode: RegPassFocus,
                        obscureText: !_isVisible1,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible1 = !_isVisible1;
                              });
                            },
                            icon: _isVisible1
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                          hintText: LocaleKeys.pass_word.tr(),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSaved: (val) => setState(() {
                          RegPass = val!;
                        }),

                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ), //SOME SPACING

                    //REGISTRATION BUTTON
                    InkWell(
                      onTap:() async {
                        FocusScope.of(context).unfocus();
                        RegformKey.currentState!.save();

                        bool tests = false;

                        //FIELD VALIDATION
                        tests=RegisterValidator(context,RegCode,RegMail,RegFirst,RegLast,gender[position],stat[index],dateTime,RegPhone,dept[pos],RegPass);



                        // ADD USER TO DATABASE
                        if(!tests)
                        {
                          try{
                            // CHECK IF CODE EXISTS ALREADY
                            final snapshot = await FirebaseFirestore.instance.collection('users').doc('$RegCode').get();
                            // CHECK IF MAIL IS USED ALREADY
                            final snap=await FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: RegMail).get();
                            if(snapshot.exists){
                              //THIS CODE IS USED ALERT
                              ThisCodeExistsAlert(context);
                            }else if(snap.docs.length!=0){
                              //THIS MAIL IS USED ALERT
                              ThisMailExistsAlert(context);
                            }else{

                              //ADD USER TO THE USERS TABLE
                              createUser(code: RegCode, firstName: RegFirst, lastName: RegLast,
                                  phone: RegPhone, mail: RegMail, department: deptEN[pos],

                                  password: encryptPassword(RegPass),

                                  birthdate: dateTime, address: statEN[index], gender: genderEN[position], image_path: "", activated: false);

                              //IF EVERYTHING IS OKAY WE GO TO THE SUCCESS PAGE
                              Get.to(RegistrationValidation(),
                                  transition: Transition.rightToLeft);
                            }
                                }
                          catch (e){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text(LocaleKeys.somethingwrong.tr()+e.toString())))
                                .closed
                                .then((value) => ScaffoldMessenger.of(context)
                                .clearSnackBars());
                          }
                        }

                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: widget.size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: ButtonColor(Theme.of(context)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.REGISTER.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    //SOME SPACING
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  String encryptPassword(String pass){
    String encryptedPassword="";
    for(int i=0; i<pass.length;i++){
      encryptedPassword+=String.fromCharCode(pass.codeUnitAt(i)+pass.length);
    }
    return encryptedPassword;
  }
}