import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/HomePage/Post.dart';
import 'package:mae_application/Services/My_Services.dart';
import 'package:mae_application/Services/storage_service.dart';

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../SideBar/SideBar.dart';
import '../translations/locale_keys.g.dart';
import 'PostEdit.dart';
import 'addPost.dart';

class PostManager extends StatefulWidget {
  const PostManager({Key? key}) : super(key: key);

  @override
  State<PostManager> createState() => _PostManagerState();
}

class _PostManagerState extends State<PostManager> {

  FB_Storage storage = FB_Storage();

  Widget retrieveImage(String img_path) {
    return FutureBuilder(
      future: storage.downloadURL("post pics", img_path+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyThemes.darkgreen,            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ClipRRect(
            //borderRadius: BorderRadius.circular(20),
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          );
        }else if(!snapshot.hasData){
          return ClipRRect(//borderRadius: BorderRadius.circular(20),
            child:  Image.asset(
              "assets/Background/bg_logo5.png",
              height: 250,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),);}

        return Container();
      },
    );
  }

  static List<String> categ = [
    "Category",
    "Event",
    "Celebration",
    "News",
    "Other",
  ];

  Widget getCategory(String category) {
    IconData icon=Icons.more_horiz;

    final index=categ.indexWhere((element) => element == category);
    switch (index){
      case 1:
        icon=Icons.event;
        break;
      case 2:
        icon=Icons.festival_outlined;
        break;
      case 3:
        icon=Icons.newspaper;
        break;
    }
    return Row(mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: ErrorColor(Theme.of(context)),),),
        VerticalDivider(color: ErrorColor(Theme.of(context)),),
      ],);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }
  @override
  Widget build(BuildContext context) {
 return RefreshIndicator(
   color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
   backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
   onRefresh: ()async{

setState(() {

});   },
   child: WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
         onTap: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
          child: Scaffold(
            extendBodyBehindAppBar: true,
              appBar: MyAppBar(
               title: LocaleKeys.PostManagement.tr(),),
            drawer: MySideBar(),
            body: SafeArea(
              child: Expanded(
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BackgroundImage(Theme.of(context)),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Align(alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,
                          child: IconButton(icon: Icon(Icons.add),color: Colors.white,
                          onPressed: (){Get.to(addPost());},
                        ),

                        ),),
                      ),
                      SizedBox(height: 15,),

                      Expanded(
                        child: StreamBuilder<List<Post>>(
                            stream: readPosts(),
                            builder: (context, snapshot) {
                              if(snapshot.data?.length==0){
                                return Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(LocaleKeys.nopostfound.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontWeight: FontWeight.w800, fontSize: 25),),
                                    SizedBox(height:10),
                                    GestureDetector(child: Text(LocaleKeys.createonenow.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontWeight: FontWeight.w800, fontSize: 20,decoration: TextDecoration.underline),),
                                      onTap: ()=>Get.to(addPost()),)
                                  ],
                                );
                              }
                              if (snapshot.hasError) {
                                return Text(
                                    LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w800)
                              );
                              } else if (snapshot.hasData) {
                                final posts = snapshot.data!;
                                return ListView.builder(
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      endActionPane: ActionPane(
                                        extentRatio: 1,
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(onPressed: (context) async {
                                            //DELETE DOCUMENT
                                            final _post = FirebaseFirestore.instance.collection('posts').doc(posts[index].id);
                                            _post.delete();
                                            //DELETE IMAGE FROM STORAGE
                                            final ref = FirebaseStorage.instance.ref();
                                            final variable= ref.child("post pics/${posts[index].id}.jpg");
                                            await variable.delete();
                                          },
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: LocaleKeys.Delete.tr(),
                                          )
                                        ],
                                      ),
                                      startActionPane: ActionPane(
                                        extentRatio: 1,
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(onPressed: (context){
                                            Get.to(PostEdit(id: posts[index].id));
                                          },
                                            backgroundColor: MyThemes.darkgreen,
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: LocaleKeys.Edit.tr(),),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: Tiles(Theme.of(context)),
                                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          leading: getCategory(posts[index].category),
                                          title: Text(posts[index].title, maxLines:2,style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context)) ,overflow: TextOverflow.ellipsis,fontSize: 16,),),

                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,));
                              }
                            }),
                      )

                    ],
                  ),
                ),
              ),
            )

          ),
        ),
      ),
 );
  }
}
