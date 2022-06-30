import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Chat/Chat_Screen.dart';

import '../Profile/User.dart';
import '../Services/MyThemes.dart';
import '../Services/My_Services.dart';
import '../Services/storage_service.dart';
import '../Users Admin/ViewUserInfo.dart';
import '../translations/locale_keys.g.dart';

class ListOfUsers extends StatefulWidget {
  const ListOfUsers({Key? key}) : super(key: key);

  @override
  State<ListOfUsers> createState() => _ListOfUsersState();
}


class _ListOfUsersState extends State<ListOfUsers> {
  final userdata=GetStorage();
  late String code="";

  FB_Storage storage=FB_Storage();

  Widget retrieveImage(String img_path,String gender){
    return FutureBuilder(
      future:storage.downloadURL("profile pictures",img_path+".jpg"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(!snapshot.hasData){
          if(gender.compareTo("Female")==0)
            return CircleAvatar(
              radius: 30,
                backgroundImage: AssetImage("assets/FemaleAvatar.png",));
          else return CircleAvatar(
            radius: 30,
              backgroundImage: AssetImage("assets/MaleAvatar.png",));
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(snapshot.data!,),
              //child: Image.network(snapshot.data!,fit: BoxFit.cover,)
          );
        }
        if(snapshot.connectionState==ConnectionState.waiting)
        {return Center(child: CircularProgressIndicator(color: MyThemes.darkgreen,),);}
        return Container();
      },
    );
  }

  TextEditingController _searchcontroller= TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //ADDRESS DROPDOWN
  static List<String> stat=[];
  static List<String> statFR = [
    "Adresse",
    "Ariana",
    "Beja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Kef",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];
  static List<String> statEN = [
    "Address",
    "Ariana",
    "Beja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Kef",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];



  //DEPARTMENT DROPDOWN
  static List<String> dept=[];
  static List<String> deptEN = [
    "Department",
    "Accounting & Finance",
    "Customer Service",
    "Distribution",
    "Human Resources",
    "Information Technology",
    "Marketing",
    "Sales",
    "Search & Development",
  ];
  static List<String> deptFR = [
    "Département",
    "Commercial",
    "Comptabilité & Finance",
    "Distribution",
    "Informatique",
    "Recherche & Développement",
    "Ressources Humaines",
    "Service Client",
    "Vente",
  ];


  //GENDER DROPDOWN
  static List<String> gender=[];
  static List<String> genderEN = [
    "Gender",
    "Female",
    "Male",];
  static List<String> genderFR = [
    "Sexe",
    "Féminin",
    "Masculin",];


  int findIndex(List<String> list, String text){
    final index=list.indexWhere((element) => element == text);
    return index;
  }

  initialisations() {
    context.locale == Locale('en')?stat.addAll(statEN):stat.addAll(statFR);
    context.locale == Locale('en')?dept=List.from(deptEN):dept=List.from(deptFR);
    context.locale == Locale('en')?gender=List.from(genderEN):gender=List.from(genderFR);
  }

  @override
  void didChangeDependencies() {
    initialisations();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.lightgreen:Colors.white,
      backgroundColor: Theme.of(context).brightness==MyThemes.lightTheme.brightness?MyThemes.darkgreen:Colors.grey.shade800,
      onRefresh: ()async{setState(() {});},

      child: WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Padding(padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                              child: TextField(
                                style: TextStyle(color: Colors.white,fontSize: 16),
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

                      SizedBox(height: 20,),

                      Expanded(
                        child: StreamBuilder<List<User>>(
                            stream: readUsers(true),
                            builder: (context, snapshot) {
                              if(snapshot.data?.length==0){return Center(child: Text(LocaleKeys.NothingToDisplay.tr(), style: TextStyle(color: ErrorColor(Theme.of(context)), fontSize: 20, fontWeight: FontWeight.w800),),);}

                              if (snapshot.hasError) {
                                return Text(
                                    LocaleKeys.somethingwrong.tr() +'${snapshot.error}',style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w800));
                              }
                              else if (snapshot.hasData) {
                                final users = snapshot.data!;
                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    return userdata.read('code').compareTo(users[index].code)!=0?


                                    Container(
                                      child: users[index].firstName.toLowerCase().contains(_searchcontroller.text) || users[index].lastName.toLowerCase().contains(_searchcontroller.text) || users[index].code.toLowerCase().contains(_searchcontroller.text)?
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Theme.of(context).brightness==MyThemes.lightTheme.brightness && _searchcontroller.text.isEmpty ? Border.all(color: Colors.white):Border.all(color: Colors.white.withOpacity(0.5)),
                                          color: Theme.of(context).brightness==MyThemes.lightTheme.brightness? Colors.white : MyThemes.darkTheme.primaryColorLight,
                                          boxShadow:Theme.of(context).brightness==MyThemes.lightTheme.brightness?[
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: Offset(0, 2),
                                            ),
                                          ]:[
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                          ],
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        child: CupertinoListTile(
                                          leading:Row(mainAxisSize: MainAxisSize.min,
                                            children: [
                                             retrieveImage(users[index].code, users[index].gender),
                                            ],),

                                          title:Text(users[index].firstName+" "+users[index].lastName, style: TextStyle(fontWeight: FontWeight.w500, color: ErrorColor(Theme.of(context))),),

                                          subtitle: Text(dept[findIndex(deptEN, users[index].department)], style: TextStyle(color: ErrorColor(Theme.of(context)))),
                                          trailing: IconButton(
                                            onPressed: (){
                                              Get.to(ChatScreen(receiverid: users[index].code,receivername: users[index].firstName+" "+users[index].lastName,receiverimage: retrieveImage(users[index].code,users[index].gender)));
                                            },
                                            icon: Icon(Icons.message, color: ErrorColor(Theme.of(context)),),
                                          ),
                                          onTap: (){
                                            //VIEW ACCOUNT'S INFORMATION
                                            Get.to(ViewUserInfo(code: users[index].code, image: retrieveImage(users[index].code,users[index].gender), email: users[index].mail, first: users[index].firstName, last: users[index].lastName, Gender: users[index].gender , phone: users[index].phone, Department: users[index].department, address: users[index].address , dateTime: users[index].birthdate));
                                          },
                                        ),

                                      ):Container(),
                                    ):Container();
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
              )

          ),
        ),
      ),
    );
  }

}