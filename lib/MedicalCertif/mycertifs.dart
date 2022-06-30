import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/MedicalCertif/Certificate.dart';
import 'package:mae_application/translations/locale_keys.g.dart';
import '../Appbar/Header.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../SideBar/SideBar.dart';
import 'package:get/get.dart' hide Trans;

import 'FillForLeave.dart';
import 'MedForm.dart';

class MyCertifs extends StatefulWidget {
  const MyCertifs({Key? key}) : super(key: key);

  @override
  State<MyCertifs> createState() => _MyCertifsState();
}


class _MyCertifsState extends State<MyCertifs> {

  //SHARED PREFRENCES
  final userdata=GetStorage();

  late String Code="";

  void _fetchData() async{
    FirebaseFirestore.instance.collection('users').where('mail',isEqualTo: userdata.read('mail')).get().then((value) =>
        value.docs.forEach((element) {
          setState(() {
            Code=element['code'];
          });
        }));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{
        _fetchData();
      },
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: MyAppBar(
                title: LocaleKeys.mycertificates.tr(),),
              drawer: MySideBar(),
              body: SafeArea(
                child: Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BackgroundImage(Theme.of(context)),
                    child:
                    Column(
                      children: <Widget>[
                        SizedBox(height: 30,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Align(alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,
                              child: IconButton(icon: Icon(Icons.add),color: Colors.white,
                                onPressed: (){
                                //ADD CERTIF
                                  Get.to(FillLeave());
                                },
                              ),

                            ),),
                        ),
                        SizedBox(height: 15,),

                        Expanded(
                          child: StreamBuilder<List<Certificate>>(
                              stream: readMyCertifs(Code),
                              builder: (context, snapshot) {
                                if(snapshot.data?.length==0){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(LocaleKeys.nocertifsent.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontWeight: FontWeight.w800, fontSize: 25),),
                                      SizedBox(height:10),
                                      GestureDetector(child: Text(LocaleKeys.sendonenow.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontWeight: FontWeight.w800, fontSize: 20,decoration: TextDecoration.underline),),
                                        onTap: ()=>Get.to(FillLeave()),)
                                    ],
                                  );
                                }
                                else if (snapshot.hasError) {
                                  return Text(LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800));
                                }else if (snapshot.hasData) {
                                  final certs = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: certs.length,
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        endActionPane: ActionPane(
                                          extentRatio: 1.0,
                                          motion: DrawerMotion(),
                                          children: [
                                            SlidableAction(onPressed: (context) async {
                                              //DELETE DOCUMENT
                                              final _post = FirebaseFirestore.instance.collection('certificates').doc(certs[index].code);
                                              _post.delete();
                                              //DELETE IMAGE FROM STORAGE
                                              final ref = FirebaseStorage.instance.ref();
                                              final variable= ref.child("certifications/${certs[index].code}.jpg");
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
                                          extentRatio: 1.0,
                                          motion: DrawerMotion(),
                                          children: [
                                            SlidableAction(onPressed: (context){
                                              if(certs[index].approved =="")
                                                {
                                                  Get.to(MedForm(person: Code,code: certs[index].code, start: certs[index].start,end: certs[index].end,reason: certs[index].reason,refusal_reason: certs[index].refusal_reason,update: true,));
                                                }
                                              else{
                                                CantEditCertifAlert(context);
                                              }
                                            },
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              label: LocaleKeys.Edit.tr(),),
                                          ],
                                        ),
                                        child:  Container(
                                          decoration: Tiles(Theme.of(context)),
                                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            trailing: CircleAvatar(
                                              radius: 15,
                                                backgroundColor: certs[index].approved== "Yes" ? Colors.green: certs[index].approved== "No"? Colors.red: Colors.yellow,
                                                ),
                                            title: Text(certs[index].reason.compareTo("Other")==0? certs[index].OtherReason:certs[index].reason, style: TextStyle(color: ErrorColor(Theme.of(context)),fontWeight: FontWeight.w800, overflow: TextOverflow.ellipsis),),
                                            subtitle: Text(DateFormat('dd/MM/yyyy').format((certs[index].sent)),style: TextStyle(color: ErrorColor(Theme.of(context)), overflow: TextOverflow.ellipsis),),
                                       onTap: (){
                                           Get.to(MedForm(person: Code,code: certs[index].code, start: certs[index].start,end: certs[index].end,reason: certs[index].reason,refusal_reason: certs[index].refusal_reason,update: false,));
                                       },

                                          ),
                                        ),


                                      );
                                    },
                                  );
                                }else{
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