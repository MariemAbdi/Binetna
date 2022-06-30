import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mae_application/Services/storage_service.dart';
import 'package:mae_application/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:permission_handler/permission_handler.dart';

import 'MyThemes.dart';

class FullScreen extends StatefulWidget {
  late String imageName;
  late String folder;

  FullScreen({required this.imageName, required this.folder,});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            retrieveImage()
          ],
        ),
        body:  Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              height: double.infinity,
              child: FullScreenWidget(
                child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                    child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: retrieveFullImage(),
                )),),
            ),
          ),
        )
      ),
    );
  }

  FB_Storage storage=FB_Storage();

  Widget retrieveFullImage(){
    return FutureBuilder(
      future:storage.downloadURL(widget.folder,widget.imageName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting){return Container(width:15,height: 15,child: Center(child: FittedBox(fit: BoxFit.fitWidth,child: CircularProgressIndicator(color: MyThemes.darkgreen,)),));}

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return Image.network(
            snapshot.data!,
            //fit: BoxFit.cover,
          );
        }

        return Container();
      },
    );
  }
  Widget retrieveImage(){
    return FutureBuilder(
      future:storage.downloadURL(widget.folder,widget.imageName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return IconButton(
            icon: Icon(Icons.download, color: Colors.grey,),
            onPressed: () async{
              var status= await Permission.storage.request();
              if(status.isGranted){
                try{
                  var response = await Dio().get(snapshot.data!.toString(),
                      options: Options(responseType: ResponseType.bytes));
                  await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data), quality: 60, name: widget.imageName.substring(0,widget.imageName.length-4)
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      content:
                      Text(LocaleKeys.imagedownloaded.tr())))
                      .closed
                      .then((value) => ScaffoldMessenger.of(context)
                      .clearSnackBars());

                }catch(e){
                  print("the Problem Is: ${e.toString()}");
                }
              }
            },
          );
        }

        return Container();
      },
    );
  }

}
