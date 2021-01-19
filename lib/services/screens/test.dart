import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopify_image/services/screens/image_item.dart';
import 'multi_image.dart';

class GalleryPageOne extends StatefulWidget {
  String uid;
  GalleryPageOne({Key key, this.uid}) : super(key: key);


  static final String path = "lib/src/pages/misc/gallery1.dart";

  @override
  _GalleryPageOneState createState() => _GalleryPageOneState();
}

class _GalleryPageOneState extends State<GalleryPageOne> {
  // final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  //   const StaggeredTile.count(2, 2),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(2, 2),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(1, 1),
  //   const StaggeredTile.count(2, 1),
  //   const StaggeredTile.count(1, 2),
  //   const StaggeredTile.count(1, 1),
  // ];

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
          if (!snapshot.hasData) return CircularProgressIndicator();
          print("Snapshot data : ${snapshot.data.toString()}");
          return ListView.builder(
           itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) =>   _buildListItem(context, snapshot.data.docs[index]),

          );
        },
      ),
    );
  }



  Widget _buildstaggered (BuildContext context, DocumentSnapshot document){
   print(document['Url'][0]);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://imgur.com/iar2s9Z.pngc"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10.0)),

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
                  new Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(document['Url'][0])),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text(
                    "#memehashtag",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],

              ),
              new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Container(),
                ),
              )
            ],

          ),
        ),
        //         Main picture
        GestureDetector(
//              brings up the image to focus on long press

          onLongPress: () => showDialog(
              context: context,
              builder: (context) => Container()),

//      Up voted the image on double tap TODO add animation on double tap

//      On tap opened the image comment section and gives the user chance to comment

          onTap: () {
            print("(_buildItem(context, document))");
            // pushing image id though this and use it to generate image document
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ImageItem(image: document['Im\geURL'], imagetag:  "#memehashtag")));
          },
          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            height: 600,
            placeholder: (context, url) =>
                Image.asset('assets/images/loading.gif'),
            placeholderFadeInDuration: Duration(milliseconds: 300),
            imageUrl: document['ImageURL'],
          ),
        ),

      ],
    );
  }




  }
