import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mae_application/HomePage/Article_page.dart';
import 'package:get/get.dart';

import '../Services/MyThemes.dart';
import '../Services/storage_service.dart';

class NewsCard extends StatefulWidget {

  late String title;
  late String description;
  late DateTime date_creation;
  late DateTime lastupdate;
  late String category;
  late Widget img;
  late String id;
  List<String> likes;

  NewsCard({
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
  State<NewsCard> createState() => _NewsCardState();
}

FB_Storage storage = FB_Storage();

Widget retrieveImage(String img_path) {
  return FutureBuilder(
    future: storage.downloadURL("post pics", img_path+".jpg"),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(
            color: MyThemes.darkgreen,
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent
                  ])),
          child: Image.network(
            snapshot.data!,
            fit: BoxFit.cover,
          ),
        );
      }else if(!snapshot.hasData){
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent
                  ])),
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


class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(Article(title: widget.title, description: widget.description, date_creation: widget.date_creation, category: widget.category, img: retrieveImage(widget.id), lastupdate: widget.lastupdate,likes: widget.likes,id: widget.id,));
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height *0.3 ,
          child: Stack(
            children: [
              Positioned.fill(
                child: widget.img, //ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset("assets/NoPhoto.jpg", fit: BoxFit.cover),),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent
                            ]))),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      widget.title,
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 19),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textDirection: widget.title.contains(RegExp("[a-zA-Z]"))?ui.TextDirection.ltr:ui.TextDirection.rtl,
                    ),
                  ),
                ),
                alignment: widget.title.contains(RegExp("[a-zA-Z]"))?Alignment.topLeft:Alignment.topRight,
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(children: [
                          Icon(Icons.access_time, size: 18, color: Colors.white,),
                          SizedBox(width: 7,),
                          Text(DateFormat('dd/MM/yyyy').format((widget.date_creation)), style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,),),
                        ],),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(children: [
                          Text((widget.likes.length).toString(),style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,) ),
                          SizedBox(width: 7,),
                          Icon(Icons.favorite, size: 18, color: Colors.white,),
                        ],),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
