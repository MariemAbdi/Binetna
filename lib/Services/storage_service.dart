import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FB_Storage{
  final firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String folder,String filePath, String filename) async{
    File file= File(filePath);
    try{await storage.ref('$folder/$filename').putFile(file);
    }catch(e){
      print(e.toString());
    }
  }

  Future<String> downloadURL(String folder, String imageName) async{
    String downloadURL = await storage.ref('$folder/$imageName').getDownloadURL();
    //print(downloadURL);
    return downloadURL;
  }

}