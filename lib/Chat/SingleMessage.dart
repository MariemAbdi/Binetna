import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Services/MyThemes.dart';

class SingleMessage extends StatefulWidget {

  final String message;
  final String receiverid;
  final bool isMe;
  final String type;
  final String sent;


  SingleMessage({required this.message,required this.isMe, required this.receiverid,required this.type,required this.sent});
  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  final currentUser=GetStorage();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isMe? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: widget.type.compareTo('text')==0?CrossAxisAlignment.center:CrossAxisAlignment.end,
      children: [
        Visibility(
            visible: widget.isMe,
            child: Text(widget.sent
              ,style: TextStyle(fontSize: 11),)),


        widget.type.compareTo("text")==0?
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(3),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(color: widget.isMe? MyThemes.lightgreen: MyThemes.darkgreen,
          borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Text(widget.message, style: TextStyle(color: Colors.white),),
        ):Container(
          margin: EdgeInsets.all(3),
          height: MediaQuery.of(context).size.height/2.5,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(border: Border.all(),
            color: widget.isMe? MyThemes.lightgreen.withOpacity(0.5): MyThemes.darkgreen.withOpacity(0.5),),
          child: widget.message!=""?Image.network(widget.message,fit: BoxFit.contain,):
          CircularProgressIndicator(color: MyThemes.darkgreen,),
        ),
        Visibility(
          visible: !widget.isMe,
            child: Text(widget.sent,style: TextStyle(fontSize: 11)),)
      ],
    );
  }
}
