
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/crud/edit_Nots.dart';
import 'package:flutter_app/crud/view.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  CollectionReference noterdf = FirebaseFirestore.instance.collection('notes');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('MENU'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Logout')
                  ],
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: noterdf
            .where('userid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .get(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshat ) {
          if ( snapshat.hasData) {
            return ListView.builder(
                itemCount: snapshat.data!.docs.length,
                itemBuilder: (context, i) {
                  return Dismissible(
                      onDismissed: (diretion) async {
                        await noterdf.doc(snapshat.data!.docs[i].id).delete();
                        await FirebaseStorage.instance
                            .refFromURL(snapshat.data!.docs[i]['imageurl'])
                            .delete()
                            .then((value) =>
                            print('Deleet'));
                        print('===================');
                      },
                      key: UniqueKey(),
                      child: ListNotes(
                        notes: snapshat.data!.docs[i],
                        docid: snapshat.data!.docs[i].id,
                      ));
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('addnots');
        },
      ),
    );
  }
}
//
class ListNotes extends StatelessWidget {
  final docid;
  final notes;

  ListNotes({this.notes, this.docid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return ViewNote(notes: notes,);
        }));
      },
     child: Card(
      color:Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              '${notes['imageurl']}',
              fit: BoxFit.fill,
              height: 80,
            ),
          ),
          Expanded(
              flex: 3,
              child: ListTile(
                title: Text('${notes['titel']}'),
                subtitle: Text("${notes['nots']}"),

                leading: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.delete),
                ),
                trailing: IconButton(
                  onPressed: () {
                    //  Navigator.of(context).pushNamed('editnots');
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNots(
                        docid: docid,
                        lest: notes,
                      );
                    }));
                  },
                  icon: Icon(Icons.edit),
                ),
              ))
        ],
      ),
    ));
  }
}
