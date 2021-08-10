import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('MENU'),
        actions: [
          DropdownButton(
              icon: Icon(Icons.more_vert,color: Colors.black,),
              items:[
                DropdownMenuItem(child: Row( children: [
                  Icon(Icons.exit_to_app),
                  SizedBox(height: 8,),
                  Text('Logout')
                ],),
                  value: 'logout',
                )
              ],
            onChanged: (itemIdentifier){
                if(itemIdentifier=='logout'){
                  FirebaseAuth.instance.signOut();
                }

            },
          )
        ],
      ),
      body: Container(
        child: Text('monaf'),
      ),
    );
  }
}
