import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Appbar/Header.dart';

import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';
import 'Post.dart';
import 'SearchPerCategory.dart';

class Article extends StatefulWidget {

  late String title;
  late String description;
  late DateTime date_creation;
  late DateTime lastupdate;
  late String category;
  late Widget img;
  late String id;
  late  List<String> likes;

  Article({
    required this.title,
    required this.description,
    required this.date_creation,
    required this.lastupdate,
    required this.category,
    required this.img,
    required this.id,
    required this.likes,
  });

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {

  late bool liked=false;

  //SHARED PREFRENCES
  final userdata=GetStorage();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

    if(widget.likes.contains(userdata.read('code')))
    setState(() {
      liked=true;
    });
  }

  //CATEGORY DROPDOWN
  int position = 0;
  static List<String> categ=[];
  static List<String> categEN = [
    "Category",
    "Event",
    "Celebration",
    "News",
    "Other",
  ];
  static List<String> categFR = [
    "Catégorie",
    "Événement",
    "Fête",
    "Nouvelles",
    "Autre",
  ];

  int findIndex(List<String> list, String text) {
    final index = list.indexWhere((element) => element == text);
    return index;
  }

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?categ=List.from(categEN):categ=List.from(categFR);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{

        setState(() {

        });   },
      child: GestureDetector(
        onHorizontalDragUpdate: (details){
          if(details.delta.direction <=0){
            Navigator.pop(context);
          }
        },
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          appBar: MyAppBar(
            title: widget.title,),
          body: SafeArea(
            child: Expanded(
              child: Container(
                width: double.infinity,
                decoration: BackgroundImage(Theme.of(context)),
                child: SingleChildScrollView(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(children:[
                              widget.img,
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.transparent
                                          ]))),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(children: [
                                          IconButton(
                                            icon: liked?Icon(Icons.favorite, size: 30, color: Colors.red,)
                                                : Icon(Icons.favorite_border_outlined, size: 30,),
                                              onPressed: () async {
                                                setState(() {
                                                  liked = !liked;
                                                  updateLikes(widget.id, userdata.read('code'),liked);
                                                });

                                              }),

                                        ],),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                child: Text(widget.title,maxLines: null,
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontSize: 35,
                                    color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.start,
                                  textDirection: widget.title.contains(RegExp("[a-zA-Z]"))?ui.TextDirection.ltr:ui.TextDirection.rtl,
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                child: Text(
                                  categ[findIndex(categEN, widget.category)],
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontSize: 25,
                                      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Colors.white,
                                    fontWeight: FontWeight.w300,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                onTap: (){
                                  Get.to(PerCatgory(category: widget.category,));
                                },
                              ),
                              SizedBox(height: 10),
                              Text(LocaleKeys.creationdate.tr()+DateFormat('dd/MM/yyyy').format((widget.date_creation)),
                                style: TextStyle(
                                    color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Colors.black:Colors.white,
                                    fontSize: 14,fontFamily: 'Avenir',overflow: TextOverflow.visible),),
                              SizedBox(height: 5),
                              Text(LocaleKeys.updatedate.tr()+DateFormat('dd/MM/yyyy').format((widget.lastupdate)),
                                style: TextStyle(
                                    color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Colors.black:Colors.white,
                                    fontSize: 14,fontFamily: 'Avenir',overflow: TextOverflow.visible),),
                              SizedBox(height: 5,),Divider(color: ErrorColor(Theme.of(context))),
                              SizedBox(height: 32),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: Theme.of(context).brightness==MyThemes.lightTheme.brightness
                                      ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.grey.shade200,
                                  ]
                                ):LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.grey.shade700,
                                        Colors.grey.shade800,
                                      ]
                                  ),
                                ),
                                child: Text(widget.description,//widget.description.startsWith(RegExp(r'^[a-zA-Z]'))
                                  textDirection: widget.description.startsWith(RegExp("[a-zA-Z]"))?ui.TextDirection.ltr:ui.TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontSize: 20,
                                    color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Colors.black:Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),textAlign: TextAlign.justify,
                                ),
                              ),

                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

