import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mae_application/Certif%20Admin/viewCertif.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mae_application/Services/MyThemes.dart';

import '../HomePage/Home.dart';
import '../MedicalCertif/Certificate.dart';
import '../Services/My_Services.dart';
import '../translations/locale_keys.g.dart';

class UnreadCertifs extends StatefulWidget {
  const UnreadCertifs({Key? key}) : super(key: key);

  @override
  State<UnreadCertifs> createState() => _UnreadCertifsState();
}

class _UnreadCertifsState extends State<UnreadCertifs> {

  late TextEditingController alertController;
  String why='';

  //REASON DROPDOWN
  static List<String> reasons=[];
  int position = 0;
  static List<String> reasonsEN = [
    "Reason",
    "Common Cold",
    "Covid-19",
    "Hospitalization",
    "Injury",
    "Sore Throat/Flu",
    "Virus",
    "Other",
  ];
  static List<String> reasonsFR = [
    "Cause",
    "Angine/Grippe",
    "Blessure",
    "Covid-19",
    "Hospitalisation",
    "Rhume",
    "Virus",
    "Autre",
  ];

  @override
  void didChangeDependencies() {
    context.locale == Locale('en')?reasons=List.from(reasonsEN):reasons=List.from(reasonsFR);
    super.didChangeDependencies();
  }

  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    alertController=TextEditingController();
  }
  @override
  void dispose() {
    alertController.dispose();
    super.dispose();
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
          onHorizontalDragUpdate: (details){
            if(details.delta.direction <=0){
              Get.to(HomePage());
            }
          },

          onTap: (){
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
          },
          child: Scaffold(
              extendBodyBehindAppBar: true,
              body:  SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BackgroundImage(Theme.of(context)),
                  child: Expanded(
                    child: StreamBuilder<List<Certificate>>(
                        stream: readCertifs(""),
                        builder: (context, snapshot) {
                          if(snapshot.data?.length==0){return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),),);}

                          if (snapshot.hasError) {
                            return Text(
                                LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800));
                          }
                          else if (snapshot.hasData) {
                            final certifs = snapshot.data!;
                            return ListView.builder(
                              itemCount: certifs.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 1.0,
                                    motion: DrawerMotion(),
                                    children: [
                                      SlidableAction(onPressed: (context) async {
                                        // SPECIFY WHY
                                        final why= await openDialog();
                                        if(why==null || why.isEmpty){return;}

                                          setState(() {
                                            this.why=why;
                                          });

                                        if(why!=null && why.isNotEmpty){
                                          final docUser = FirebaseFirestore.instance.collection('certificates').doc(certifs[index].code);
                                          //UPDATE THE FIELDS
                                          docUser.update({
                                            'approved': "No",
                                            'refusal_reason':why,
                                          });
                                        }

                                      },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.clear,
                                        label: LocaleKeys.Deny.tr(),
                                      )
                                    ],
                                  ),
                                  startActionPane: ActionPane(
                                    extentRatio: 1.0,
                                    motion: DrawerMotion(),
                                    children: [
                                      SlidableAction(onPressed: (context){
                                        final docUser = FirebaseFirestore.instance.collection('certificates').doc(certifs[index].code);
                                        //UPDATE THE FIELDS
                                        docUser.update({
                                          'approved': "Yes",
                                        });
                                      },
                                        backgroundColor: MyThemes.darkgreen,
                                        foregroundColor: Colors.white,
                                        icon: Icons.check,
                                        label: LocaleKeys.Approve.tr(),),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: Tiles(Theme.of(context)),
                                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      leading:Row(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(certifs[index].person, style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context))),),
                                          ),
                                          VerticalDivider(color: ErrorColor(Theme.of(context)),),
                                        ],),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(certifs[index].reason.compareTo("Other")==0? certifs[index].OtherReason:reasons[findIndex(reasonsEN, certifs[index].reason)], style: TextStyle(fontWeight: FontWeight.bold, color: ErrorColor(Theme.of(context))),overflow: TextOverflow.ellipsis,),
                                          SizedBox(height: 4,),

                                          Text(DateFormat('dd/MM/yyyy').format((certifs[index].sent)),style: TextStyle(color: ErrorColor(Theme.of(context)), overflow: TextOverflow.ellipsis),),

                                        ],
                                      ),
                                      onTap: (){
                                        Get.to(viewCertif(otherReason:certifs[index].OtherReason,code:certifs[index].code,end: certifs[index].end, person: certifs[index].person, start: certifs[index].start, reason: certifs[index].reason,refusal_reason: certifs[index].refusal_reason,));
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,));
                          }

                        }),
                  ),
                ),
              )

          ),
        ),
      ),
    );
  }
  Future<String?> openDialog()=>showDialog<String>(context: context, builder: (context)=> AlertDialog(
    title: Text(LocaleKeys.DenialReason.tr()),
    content: TextField(
      autofocus: true,
      controller: alertController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 3, color: MyThemes.darkgreen),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 3, color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: LocaleKeys.DenialReason.tr(),
        hintStyle: TextStyle(color: Colors.black)
      ),
    ),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop(alertController.text);
        alertController.clear();
      }, child: Text(LocaleKeys.DONE, style: TextStyle(color: MyThemes.darkgreen),))
    ],
  ));
}
