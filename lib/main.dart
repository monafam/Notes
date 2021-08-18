import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/crud/edit_Nots.dart';
import 'package:flutter_app/screen/auth_screen.dart';
import 'package:flutter_app/screen/menu_screen.dart';

import 'crud/add_Notes.dart';

// @dart=2.9
void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(


  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          )
        )

      ),
      routes: {
        'addnots':(context)=>addNotes(),
        'menuScreen':(context)=>MenuScreen(),
        'editnots':(context)=>EditNots(),

      },
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (ctx,snapShot) {
        if(snapShot.hasData){
          return MenuScreen();
        }else{
          return AuthScreen();
        }
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
