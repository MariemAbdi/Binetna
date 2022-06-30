import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({Key? key, required this.text, required this.icon, required this.onPressed}) : super(key: key);

  final String text;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white,),
            SizedBox(width: 20,),
            Flexible(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(text,style: TextStyle(fontSize: 20, color: Colors.white, overflow: TextOverflow.ellipsis,
                  ),maxLines: 1,softWrap: true,),
                )


            ),
          ],
        ),
      ),
    );
  }
}
