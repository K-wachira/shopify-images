import 'package:flutter/material.dart';
import 'package:shopify_image/services/screens/test.dart';


class Home extends StatefulWidget {
  String uid;
  Home({Key key, this.uid}) : super(key: key);



  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GalleryPageOne(uid:  widget.uid,)
    );
  }
}
