import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/storage_service.dart';
import '../translations/locale_keys.g.dart';
import 'Card.dart';
import 'Post.dart';

class PerCatgory extends StatefulWidget {
  late String category;

  PerCatgory({
    required this.category});

  @override
  State<PerCatgory> createState() => _PerCatgoryState();
}

class _PerCatgoryState extends State<PerCatgory> {
  final _searchcontroller = TextEditingController();

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
        if (!snapshot.hasData){
          return ClipRRect(borderRadius: BorderRadius.circular(20),
            child:  Image.asset(
              "assets/Background/bg_logo5.png",
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),);
        }
        return Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
      },
      child: Scaffold(
        appBar: MyAppBar(title: LocaleKeys.searchPage.tr(),),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BackgroundImage(Theme.of(context)),
            child: Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Flexible(
                        child: Padding(padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                          child: TextField(
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                            decoration: InputDecoration(
                              hintText: LocaleKeys.Search.tr(),
                              prefixIcon: Icon(Icons.search, color: Colors.white, size: 20,),
                              filled: true,
                              fillColor: Colors.grey,
                              contentPadding: EdgeInsets.all(8),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              suffixIcon: _searchcontroller.text.isEmpty
                                  ? null
                                  : IconButton(
                                icon: Icon(Icons.close, color: Colors.white,),
                                onPressed: () {
                                  _searchcontroller.clear();
                                  FocusScope.of(context).unfocus();
                                  setState(() {});
                                },
                              ),
                            ),
                            onChanged: (search){
                              setState(() {
                                _searchcontroller.text;
                              });
                            },
                            controller: _searchcontroller,
                          ),),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Container(color: Colors.green,)),
                  SizedBox(height: 15,),
                  Expanded(
                    child: StreamBuilder<List<Post>>(
                        stream: PerCatgeoryPosts(widget.category),
                        builder: (context, snapshot) {
                          if(snapshot.data?.length==0){return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),),);}

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800)),
                            );
                          } else if (snapshot.hasData) {
                            final posts = snapshot.data!;
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                if(_searchcontroller.text.isNotEmpty)
                                {if(posts[index].title.toLowerCase().contains(_searchcontroller.text)){
                                  return NewsCard(
                                    title: posts[index].title,
                                    date_creation:
                                    posts[index].creation_date,
                                    description: posts[index].description,
                                    category: posts[index].category,
                                    img: retrieveImage(
                                        posts[index].id),
                                    id: posts[index].id,
                                    lastupdate: posts[index].lastupdate,
                                    likes: posts[index].likes,
                                  );
                                }else {
                                  return Container();}}
                                else{return NewsCard(
                                  title: posts[index].title,
                                  date_creation:
                                  posts[index].creation_date,
                                  description: posts[index].description,
                                  category: posts[index].category,
                                  img: retrieveImage(
                                      posts[index].id),
                                  id: posts[index].id,
                                  lastupdate: posts[index].lastupdate,
                                  likes: posts[index].likes,
                                );}
                              },
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
        ),
      ),
    );
  }
}