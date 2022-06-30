import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/translations/locale_keys.g.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../Appbar/Header.dart';
import '../Services/My_Services.dart';
import '../Services/Validators.dart';

class EditOffer extends StatefulWidget {
  late String id;
  late String destinations;
  late DateTime date;
  late List<String> list;

  EditOffer({
    required this.id,
    required this.destinations,
    required this.date,
    required this.list
  });

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {

  final destinationsController = TextEditingController();
  final daytimeController = TextEditingController();
  final TextfieldTagsController _controller= TextfieldTagsController();
  final conditionsController = TextEditingController();


  // PLACES DROPDOWN
  int position = 0;
  static List<String> places = [
    "Places", "1", "2", "3", "4",
  ];
  static List<String> _places = [
    "0", "1", "2", "3", "4",
  ];

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

  void initialisations() async{
    FirebaseFirestore.instance.collection('carpooling').where('id',isEqualTo: widget.id).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            daytimeController.text=DateFormat('dd/MM/yyyy - kk:mm').format((element['day_time']).toDate());
            destinationsController.text=widget.destinations;
            position=findIndex(_places,element['places'].toString());
            conditionsController.text=element['conditions'];
          });
        }));}

  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    setState(() {
      date_time=widget.date;
    });
    _fetchData();
    initialisations();
  }

  @override
  void dispose() {
    destinationsController.dispose();
    daytimeController.dispose();
    _controller.dispose();
    conditionsController.dispose();
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
        appBar: MyAppBar(
          title: destinationsController.text,
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
                                        child: Text(LocaleKeys.DONE.tr()),
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
                              initialTags: widget.list,
                              textSeparators: const [' ', ','],
                              letterCase: LetterCase.normal,
                              validator: (String tag) {
                                if (_controller.getTags!.contains(tag)) {
                                  return 'you already entered that';
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
                                      icon: Icon(Icons.directions_car),
                                      isDense: true,
                                      border: InputBorder.none,
                                      helperStyle: const TextStyle(
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      hintText: _controller.hasTags ? '' : "Enter Destination...",
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
                                    icon: Icon(Icons.close),
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
                              {final docUser = FirebaseFirestore.instance.collection('carpooling').doc(widget.id);
                                //UPDATE THE FIELDS
                                docUser.update({
                                  'day_time': date_time,
                                  'places': int.parse(places[position]),
                                  'destinations':  _controller.getTags,
                                  'conditions': conditionsController.text,
                                });

                                initialisations();

                                UpdateSuccessAlert(context);
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
