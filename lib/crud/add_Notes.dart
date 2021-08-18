import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class addNotes extends StatefulWidget {
  @override
  _addNotesState createState() => _addNotesState();
}

class _addNotesState extends State<addNotes> {
  CollectionReference noteref = FirebaseFirestore.instance.collection('notes');
  var ref;
   late File file;

  var title, note, imegurl;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  void _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CircularProgressIndicator(),
        );
      },
    );
  }

  addNot(context) async {
    // if (file == null){
    //   return AwesomeDialog(
    //       context: context,
    //       title: 'Error',
    //       body: Text('Please choos Images'),
    //       dialogType: DialogType.ERROR)
    //     ..show();}
    var isValid = formstate.currentState!.validate();
    if (isValid) {
      _openLoadingDialog(context);

    formstate.currentState!.save();
      await ref.putFile(file);
      imegurl = await ref.getDownloadURL();
      await noteref.add({
        'titel': title,
        'nots': note,
        'imageurl': imegurl,
        'userid': FirebaseAuth.instance.currentUser.uid
      });
      Navigator.of(context).pushNamed('menuScreen');
    CircularProgressIndicator;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Nots'),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
            key: formstate,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty || val.length > 20) {
                      return 'Please enter least character';
                    }
                    if (val.length < 2) {
                      return 'Please enter least character';
                    }
                  },
                  onSaved: (val) {
                    title = val;
                  },
                  maxLength: 30,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Title Note',
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty || val.length > 255) {
                      return 'Please enter least character';
                    }
                    if (val.length < 15) {
                      return 'Please enter least character';
                    }
                  },
                  onSaved: (val) {
                    note = val;
                  },
                  minLines: 1,
                  maxLength: 300,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Title Note',
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
                RaisedButton(
                    onPressed: () {
                      showBottmShet(context);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 19),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text('Add Imege For not'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                    onPressed: () async {
                      await addNot(context);
                    },
                    child: Text('Add Not'),
                    color: Colors.lightBlue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)))
              ],
            ),
          )
        ],
      )),
    );
  }

  showBottmShet(context) {
    var ctx;
    return showModalBottomSheet(
        context: context,
        builder: (ccontext) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please Choose Image',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(10000);
                      var nameimeg = '$rand' + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref('images')
                          .child('$nameimeg');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'From Camera',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(10000);
                      var nameimeg = '$rand' + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref('images')
                          .child('$nameimeg');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'From Gallery',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
