import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../Appbar/Header.dart';
import '../Services/My_Services.dart';
import '../Services/Notifications.dart';
import '../Services/Validators.dart';
import '../translations/locale_keys.g.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({Key? key}) : super(key: key);

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {

  // PLACES DROPDOWN
  int position = 0;
  static List<String> places = [
    "Places", "1", "2", "3", "4",
  ];
  final TextfieldTagsController _controller= TextfieldTagsController();
  final conditionsController = TextEditingController();


  final user=GetStorage();

  late String First="";
  late String Last="";
  late String Department="";
  late String Phone="";
  late DateTime date_time=DateTime.now();

  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('code',isEqualTo: user.read('code')).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            First=element['firstName'];
            Last=element['lastName'];
            Department=element['department'];
            Phone=element['phone'];
          });
        }));}

  @override
  void initState() {
  super.initState();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  _fetchData();
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
        appBar: MyAppBar(
          title: LocaleKeys.AddCarpooling.tr(),
        ),
        body: SafeArea(
          child: Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BackgroundImage(Theme.of(context)),
              child: SingleChildScrollView(
                  child: Form(
                    child: Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(LocaleKeys.OfferedBy.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),),
                          SizedBox(height: 20,),

                          //FIRST NAME FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.name,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.face),
                                  hintText: First,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //LAST NAME FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.name,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.face),
                                  hintText: Last,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //DEPARTMENT FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.work),
                                  hintText: Department,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //PHONE FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.number,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  hintText: Phone,
                                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING


                          Divider(color: ErrorColor(Theme.of(context)),thickness: 1,height: 10,indent: 50,endIndent: 50,),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING


                          //DAYTIME FIELD
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,),

                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                hintText: DateFormat('dd/MM/yyyy - kk:mm').format(date_time),//DateFormat('dd/MM/yyyy').format(hintBD),//dateTime.difference(DateTime.now()).inDays ==0 ? "Birthdate" : DateFormat('dd/MM/yyyy').format(dateTime),//dateTime.day.toString()+"/"+dateTime.month.toString()+"/"+dateTime.year.toString(),
                                hintStyle: TextStyle(color: DateTime.now().difference(date_time).inMinutes==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTap: (){showCupertinoModalPopup(context: context,
                                  builder: (context)=>CupertinoActionSheet(
                                    actions: [
                                      SizedBox(height: 180,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.dateAndTime,
                                          initialDateTime: date_time,
                                          maximumYear: DateTime.now().year,
                                          minimumYear: 1900,
                                          onDateTimeChanged: (dateTime){
                                            setState(() {
                                              this.date_time=dateTime;
                                            });

                                          },
                                        ),),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                        child: Text( LocaleKeys.DONE.tr()),
                                        onPressed: (){Navigator.pop(context);}
                                    ),
                                  )
                              );
                              },),),

                          SizedBox(height: 10,), //SOME SPACING

                          //DESTINATIONS FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: TextFieldTags(
                              textfieldTagsController: _controller,
                              textSeparators: const [' ', ','],
                              letterCase: LetterCase.normal,
                              validator: (String tag) {
                                if (_controller.getTags!.contains(tag)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content:
                                      Text(LocaleKeys.alreadyentered.tr())))
                                      .closed
                                      .then((value) => ScaffoldMessenger.of(context)
                                      .clearSnackBars());
                                }
                                return null;
                              },
                              inputfieldBuilder:
                                  (context, tec, fn, error, onChanged, onSubmitted) {
                                return ((context, sc, tags, onTagDelete) {
                                  return TextField(
                                    inputFormatters: [UpperCaseTextFormatter()],
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                    controller: tec,
                                    focusNode: fn,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.directions_car,),
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: _controller.hasTags ? '' : LocaleKeys.EnterDestination.tr(),
                                      errorText: error,
                                      prefixIconConstraints:
                                      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                                      suffixIcon: !_controller.hasTags
                                          ? null
                                          : IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          _controller.clearTags();
                                          setState(() {});
                                        },
                                      ),
                                      prefixIcon: tags.isNotEmpty
                                          ? SingleChildScrollView(
                                        controller: sc,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: tags.map((String tag) {
                                              //THE CONTAINER OF THE ADDED WORDS
                                              return Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: Color.fromARGB(255, 74, 137, 92),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10.0, vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: Text(
                                                        tag,
                                                        style: const TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      onTap: () {
                                                        print("$tag selected");
                                                      },
                                                    ),
                                                    const SizedBox(width: 4.0),
                                                    InkWell(
                                                      child: const Icon(
                                                        Icons.cancel,
                                                        size: 14.0,
                                                        color: Color.fromARGB(
                                                            255, 233, 233, 233),
                                                      ),
                                                      onTap: () {
                                                        onTagDelete(tag);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            }).toList()),
                                      )
                                          : null,
                                    ),
                                    //NEEDED TO ADD TAGS IN THE FIELD
                                    onChanged: onChanged,
                                    //onSubmitted: onSubmitted,
                                  );
                                });
                              },
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          // REMAINING PLACES
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
                              readOnly: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.people),
                                suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                                hintText: places[position], //gender[position],
                                hintStyle: TextStyle(color: position==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTap: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => SizedBox(
                                      height: 180,
                                      child: CupertinoPicker(
                                        scrollController:
                                        FixedExtentScrollController(
                                            initialItem: position),
                                        backgroundColor: Colors.white,
                                        itemExtent: 50,
                                        onSelectedItemChanged: (index) {
                                          setState(() {
                                            //position=findGender(gender, hintGender);
                                            this.position = index;
                                          });
                                        },
                                        looping: true,
                                        children: [
                                          for (String name in places) Text(name,style: TextStyle(color: name.compareTo("3")==0 || name.compareTo("4")==0 ? Colors.red: Colors.black),),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ), //SOME SPACING

                          //CONDITIONS FIELD
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                                maxLines: null,
                                controller: conditionsController,
                                keyboardType: TextInputType.multiline,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.warning),
                                  border: InputBorder.none,
                                  hintText: LocaleKeys.condition.tr(),
                                  suffixIcon: conditionsController.text.isEmpty
                                      ? null
                                      : IconButton(
                                    icon: Icon(Icons.close, color: Colors.white,),
                                    onPressed: () {
                                      conditionsController.clear();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),





                          SizedBox(
                            height: 10,
                          ),


                          InkWell(
                            onTap: () async {

                              FocusScope.of(context).unfocus();

                              bool tests = false;


                              //FILED VALIDATION
                              tests=CarpoolingAdd_Update(context,places[position],_controller.getTags,date_time);

                              // IF EVERYTHING IS GOOD
                              if(!tests)
                              {//ADD CARPOOLING
                              FirebaseFirestore.instance.collection('carpooling').add(
                                {'day_time': date_time,
                                  'places': int.parse(places[position]),
                                  'destinations':  _controller.getTags,
                                  'person': user.read('code'),
                                  'people':[],
                                  'accepted':[],
                                  'conditions': conditionsController.text,
                                  'id':"",
                                },).then((value) {

                                final docUser = FirebaseFirestore.instance.collection('carpooling').doc(value.id);
                                //UPDATE THE FIELDS
                                docUser.update({
                                  'id': value.id,
                                });

                                });

                              FirebaseMessaging.instance.unsubscribeFromTopic("carpooling");
                              sendPushMessage(DateFormat('dd/MM/yyyy - kk:mm').format(date_time), myDestinations(_controller.getTags!), "carpooling");
                              FirebaseMessaging.instance.subscribeToTopic("carpooling");

                              setState(() {
                                position=0;
                                _controller.clearTags();
                                date_time=DateTime.now();
                              });




                              AddedSuccessfullyAlert(context, LocaleKeys.Offer.tr());
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
                              child: Text(
                                LocaleKeys.SAVE.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
