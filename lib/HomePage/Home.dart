import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mae_application/HomePage/Card.dart';
import 'package:mae_application/HomePage/Post.dart';
import 'package:mae_application/Services/storage_service.dart';
import 'package:mae_application/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/Notifications.dart';
import '../Services/Theme_Service.dart';
import '../SideBar/SideBar.dart';
import 'SearchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    loadFCM();
    listenFCM();
  }

  @override
  void dispose() {
    super.dispose();
  }

  FB_Storage storage = FB_Storage();

  Widget retrieveImage(String img_path) {
    return FutureBuilder(
      future: storage.downloadURL("post pics", img_path+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyThemes.darkgreen,
            ),
          );
        }
        return Container();
      },
    );
  }

  //CATEGORY DROPDOWN
  int position = 0;
  static List<String> categ=[];
  static List<String> categEN = [
    "All",
    "Event",
    "Celebration",
    "News",
    "Other",
  ];
  static List<String> categFR = [
    "Tous",
    "Événement",
    "Fête",
    "Nouvelles",
    "Autre",
  ];

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?categ=List.from(categEN):categ=List.from(categFR);
    super.didChangeDependencies();
  }

  late int currentindex=0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Colors.grey.shade300: Colors.grey.shade900,
              toolbarHeight: MediaQuery.of(context).size.height/6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(MediaQuery.of(context).size.width,80),
                  )
              ),

              flexibleSpace:  Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height/8,
                      width: MediaQuery.of(context).size.height/8,
                      child: Image.asset('assets/logo-only.png', fit: BoxFit.cover,)),
                  SizedBox(height: 10,),
                ],
              ),

              actions: [
                //CHANGE THE APP'S THEME ICON
                GestureDetector(
                  child: Icon( Theme.of(context).brightness==MyThemes.lightTheme.brightness ? Icons.brightness_3_sharp : Icons.wb_sunny),
                  //WE CALL THE THEME SWITCHER METHOD
                  onTap: (){
                    ThemeService().switchTheme();

                    ThemeSwitchedAlert(context);
                  },

                ),

                //Spacing
                SizedBox(width: 30,),

                //SEARCH ICON
                GestureDetector(
                    child: Icon(Icons.search),
                    onTap: (){
                      setState(() {
                        Get.to(Search_Filter());
                      });
                    }
                ),

                //Spacing
                SizedBox(width: 20,),
              ],
            ),
            drawer: MySideBar(),
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BackgroundImage(Theme.of(context)),
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          GestureDetector(
                            child: buildCategory(Icons.list,categ[0]),
                            onTap: (){
                              setState(() {
                                currentindex=0;
                              });
                            },
                          ),
                          GestureDetector(
                            child: buildCategory(Icons.event,categ[1]),
                            onTap: (){
                              setState(() {
                                currentindex=1;
                              });
                            },
                          ),
                          GestureDetector(
                            child: buildCategory(Icons.festival_outlined,categ[2]),
                            onTap: (){
                              setState(() {
                                currentindex=2;
                              });
                            },
                          ),
                          GestureDetector(
                            child: buildCategory(Icons.newspaper,categ[3]),
                            onTap: (){
                              setState(() {
                                currentindex=3;
                              });
                            },
                          ),
                          GestureDetector(
                            child: buildCategory(Icons.more_horiz,categ[4]),
                            onTap: (){
                              setState(() {
                                currentindex=4;
                              });
                            },
                          )
                        ],),
                      ),

                      Expanded(
                        child: StreamBuilder<List<Post>>(
                            stream: currentindex==0?readPosts():PerCatgeoryPosts(categEN[currentindex]),
                            builder: (context, snapshot) {
                              if(snapshot.data?.length==0){return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),),);}

                              if (snapshot.hasError) {
                                Timer(const Duration(seconds: 20), (){});
                                return Center(
                                  child: Text(
                                      LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800)),
                                );
                              } else if (snapshot.hasData) {
                                final posts = snapshot.data!;
                                  return RefreshIndicator(
                                    color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
                                    backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
                                    onRefresh: ()async{
                                      setState(() {});   },
                                    child: ListView.builder(
                                      itemCount: posts.length,
                                      itemBuilder: (context, index) {
                                        return NewsCard(
                                          title: posts[index].title,
                                          date_creation: posts[index].creation_date,
                                          description: posts[index].description,
                                          category: posts[index].category,
                                          img: retrieveImage(posts[index].id),
                                          id: posts[index].id,
                                          lastupdate: posts[index].lastupdate,
                                          likes: posts[index].likes,
                                        );
                                      },
                                    ),
                                  );

                              } else {
                                return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,));
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  buildCategory(IconData icon,String category) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyThemes.darkgreen,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 0.5,
            spreadRadius: 0.5,
            offset: Offset(1,1),
          )
        ],
      ),
      child: Row(children: [
        Icon(icon, color: Colors.white,),
        SizedBox(width: 5,),
        Text(category, style: TextStyle(color:Colors.white),),
      ],
      ),
    );
  }
}
