import 'package:cloud_firestore/cloud_firestore.dart';

class Post{

  late String id;
  late String title;
  late String description;
  late DateTime creation_date;
  late DateTime lastupdate;
  late String category;
  late List<String> likes;

  Post({required this.id,required this.title, required this.description, required this.creation_date,required this.lastupdate,required this.category, required this.likes});

  static Post fromJson(Map<String,dynamic> json){
    return Post(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        creation_date: json['creation_date'].toDate(),
        lastupdate: json['lastupdate'].toDate(),
        category: json['category'],
        likes: json['likes'].cast<String>(),
    );}

}

  //GET A LIST OF ALL THE DOCUMENTS IN THE COLLECTION PER CATGEORY DATE ETC..
  Stream<List<Post>> PerCatgeoryPosts(String value)=>
      FirebaseFirestore.instance.collection('posts').where("category", isEqualTo: value).orderBy('creation_date', descending: true).snapshots().map((snapshot)
      => snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE DOCUMENTS IN THE COLLECTION
Stream<List<Post>> readPosts()=>
    FirebaseFirestore.instance.collection('posts').orderBy('creation_date', descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        Post.fromJson(doc.data())).toList());

Stream<List<Post>> readPostsSearch(bool title, bool date)=>
    FirebaseFirestore.instance.collection('posts').orderBy('creation_date', descending: date).orderBy('title', descending: title).snapshots().map((snapshot)
    => snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  //GET ONE POST
  Future<Post?> readPost(String id) async{
    final docPost = await FirebaseFirestore.instance.collection('posts').doc(id).get();
    if(docPost.exists) {
      return Post.fromJson(docPost.data()!);
    }
  }

  updateLikes(String postid,String userid, bool isLiked){
    final Postdoc=FirebaseFirestore.instance.collection('posts').doc(postid);
    if(isLiked){
      Postdoc.update({
        "likes": FieldValue.arrayUnion([userid]),
      });
    }else{
      Postdoc.update({
        "likes": FieldValue.arrayRemove([userid]),
      });
    }
  }

  getlist() async{
    List<Post> mylist =[];

    final snap = await FirebaseFirestore.instance.collection('posts').get();
    final map = snap.docs as Map<dynamic,dynamic>;
    map.forEach((key, value) { final post= Post.fromJson(value);
      mylist.add(post);
    });
  return mylist;}

    getlistAnothermethod() async{
      List<Post> mylist =[];

      await FirebaseFirestore.instance.collection('posts').get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((element) {
          Post obj= Post(id: element['id'], title: element['title'], description: element['description'],
              creation_date: element['creation_date'], lastupdate: element['lastupdate'], category: element['category'], likes: element['likes']);
          mylist.add(obj);
        });
      });
      return mylist;}