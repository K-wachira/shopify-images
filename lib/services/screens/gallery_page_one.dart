import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopify_image/services/screens/image_item.dart';
import 'package:shopify_image/services/screens/pop_up_menu.dart';
import 'package:shopify_image/services/shared%20widgets/spinn_kit.dart';
import 'multi_image.dart';

class GalleryPageOne extends StatefulWidget {
  String uid;
  GalleryPageOne({Key key, this.uid}) : super(key: key);


  static final String path = "lib/src/pages/misc/gallery1.dart";

  @override
  _GalleryPageOneState createState() => _GalleryPageOneState();
}

class _GalleryPageOneState extends State<GalleryPageOne> {

  final CollectionReference collectionReference=FirebaseFirestore.instance.collection("Posts");
  List<DocumentSnapshot> imagez;
  StreamSubscription<QuerySnapshot> subscription;
  var dbconn = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    subscription=collectionReference.snapshots().listen((datasnap){
      setState(() {
        imagez=datasnap.docs;

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        // leading: IconButton (
        //     icon:Icon(Icons.arrow_back),
        //         onPressed: (){},
        // ),
        title: Text(
          'Shopify',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: HexColor("#95BF46"),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.blue,
            child: Text("Add New"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MultiImage(uid: widget.uid)));

            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: dbconn.collection("Posts").snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData) return Center(child: loading_widget());
          print("Snapshot data : ${snapshot.data.toString()}");
          return ListView.builder(
           itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) =>   _buildListItem(context, snapshot.data.docs[index]),

          );
        },
      ),
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                // comment section
                children: <Widget>[
                  new Text(
                    "#Caption",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],

              ),
              new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => pop_up_menu(),
                ),
              )
            ],

          ),
        ),
        //         Main picture
        GestureDetector(
          onLongPress: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageItem(image: document['Url'][0])));

          },

          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            height: 400,
            placeholder: (context, url) =>
                loading_widget(),
            placeholderFadeInDuration: Duration(milliseconds: 300),
            imageUrl: document['Url'][0],
          ),
        ),

      ],
    );
  }




  }
