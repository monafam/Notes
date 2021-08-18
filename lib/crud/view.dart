import 'dart:ui';

import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final notes;

  const ViewNote({Key? key, this.notes}) : super(key: key);
  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Notes'),
      ),
      body: Container(
         child: Column(
           children: [
             Container(child: Image.network('${widget.notes['imageurl']}',width: double.infinity,height: 300,fit: BoxFit.fill,),),
             SizedBox(height: 20,),
             Text('${widget.notes['titel']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
             SizedBox(height: 25,),
             Text("${widget.notes['nots']}",style: TextStyle(fontSize: 20,color: Colors.greenAccent),)
           ],
         ),
      ),
    );

  }
}
