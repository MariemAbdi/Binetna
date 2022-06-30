import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mae_application/translations/locale_keys.g.dart';

import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/Validators.dart';
import '../Services/storage_service.dart';

class PostEdit extends StatefulWidget {
  late String id;

  PostEdit({
    required this.id,
  });

  @override
  State<PostEdit> createState() => _PostEditState();
}

class _PostEditState extends State<PostEdit> {
  //THE FORM KEY
  final _formKey = GlobalKey<FormState>();

  //LIST OF CONTROLLERS
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();


  //FORM FIELDS
  late String TitleField;
  late String DescriptionField;

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

  //PICKED IMAGE
  XFile? _image;

  late String img_path="";

  int findIndex(List<String> list, String text) {
    final index = list.indexWhere((element) => element == text);
    return index;
  }

  void initialisations() async{
    FirebaseFirestore.instance.collection('posts').where('id',isEqualTo: widget.id).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            TitleController.text=element['title'];
            DescriptionController.text=element["description"];
            img_path=element['id']+".jpg";
            position=findIndex(categEN, element["category"]);
          });
        }));
  }

  @override
  void initState() {
    super.initState();
    initialisations();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?categ=List.from(categEN):categ=List.from(categFR);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    TitleController.dispose();
    DescriptionController.dispose();
    super.dispose();
  }

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(){
    return FutureBuilder(
      future:storage.downloadURL("post pics",img_path),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting){return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return ClipRRect(
            //borderRadius: BorderRadius.circular(20),
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //WE GET THE DEVICE'S DIMENSIONS
    return GestureDetector(
      onTap: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);},
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: TitleController.text,
        ),
        body: SafeArea(
          child: Expanded(
            child: Container(
              width: double.infinity,
              decoration: BackgroundImage(Theme.of(context)),
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      //TITLE FIELD
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
                            controller: TitleController,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              icon: Icon(Icons.title),
                              hintText: LocaleKeys.Title.tr(),
                              border: InputBorder.none,
                              suffixIcon: TitleController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        TitleController.clear();
                                        setState(() {});
                                      },
                                    ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            onSaved: (val) => setState(() {
                              TitleField = val!;
                            }),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ), //SOME SPACING

                      //Description FIELD
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
                            controller: DescriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              icon: Icon(Icons.description),
                              hintText: LocaleKeys.Description.tr(),
                              border: InputBorder.none,
                              suffixIcon: DescriptionController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        DescriptionController.clear();
                                        setState(() {});
                                      },
                                    ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            onSaved: (val) => setState(() {
                              DescriptionField = val!;
                            }),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      //CATEGORY
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            icon: Icon(Icons.category),
                            hintText: categ[position], //gender[position],
                            hintStyle: TextStyle(color: position==0?Colors.grey.shade300:Colors.white,fontWeight: FontWeight.w800,fontSize: 16),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                            });
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
                                            this.position = index;
                                          });
                                        },
                                        looping: true,
                                        children: [
                                          for (String name in categ) Text(name),
                                        ],
                                      ),
                                    ));
                          },
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      GestureDetector(onTap: () {_SelectImageDialog();},
                          child: Container(
                            height: size.width * 0.8,
                            width: size.width *0.8,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _image==null?retrieveImage()
                                :Image(image: FileImage(File(_image!.path)),fit: BoxFit.cover,),
                          )),

                      SizedBox(
                        height: 10,
                      ),

                      InkWell(
                        onTap: () async {

                          FocusScope.of(context).unfocus();

                          _formKey.currentState!.save();

                          bool tests = false;

                          //FILED VALIDATION
                          tests=Post_Edit_Validator(context,TitleField,DescriptionField,categ[position]);

                          if(!tests)
                          {
                            final docUser = FirebaseFirestore.instance.collection('posts').doc(widget.id);
                            //UPDATE THE FIELDS
                            docUser.update({
                              'category': categEN[position],
                              'description': DescriptionField,
                              'title': TitleField,
                              'lastupdate': DateTime.now(),
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
                        height: 20,
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

//DIALOG TO SELECT IMAGE FROM GALLERY OR CAMERA
  void _SelectImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(LocaleKeys.AddPhoto.tr()),
          actions: [
            // TAKE A PHOTO : CAMERA
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.camera);
                setState(() {

                });
              },
              child: Text(LocaleKeys.TakePhoto.tr(),style: TextStyle(color: Colors.black),),
            ),

            // CHOOSE A PHOTO : GALLERY
            CupertinoActionSheetAction(
              onPressed: () {
                _handleImage(source: ImageSource.gallery);
                setState(() {

                });
              },
              child: Text(LocaleKeys.ChoosePhoto.tr(),style: TextStyle(color: Colors.black)),
            ),
          ],

          // CANCEL
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              LocaleKeys.Cancel.tr(),
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  Future uploadImage() async{
    final file = File(_image!.path);
    //final path = 'profile pictures/${_image!.name}';
    final path = 'post pics/${widget.id+".jpg"}';

    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

    final docUser = FirebaseFirestore.instance.collection('posts').doc(widget.id);
    //UPDATE THE FIELDS
    docUser.update({
      'image_path': '${widget.id+".jpg"}'
    });
    setState(() {

    });
  }


  //OPENING FOLDER / CAMERA
  void _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    try {
      XFile? imageFile = await ImagePicker().pickImage(source: source);
      if (imageFile != null) {
        setState(() {
          _image = imageFile;
        });
        //SAVE THE PICTURE TO THE FIREBASE STORAGE
        uploadImage();
setState(() {

});
      }} on PlatformException catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString()))).closed
          .then((value) =>
          ScaffoldMessenger.of(context).clearSnackBars());
    }
  }
}
