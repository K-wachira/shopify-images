import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This class handels a more pop up menu


class MorePopUpMenu extends StatefulWidget {
  String uid;
  String ownerid;
  MorePopUpMenu({Key key, this.uid, this.ownerid}) : super(key: key);



  @override
  _MorePopUpMenuState createState() => _MorePopUpMenuState();
}

class _MorePopUpMenuState extends State<MorePopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.grey.shade300,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(height: 30,),
        GestureDetector(
          onTap: (){
            if (widget.ownerid == widget.uid){
              FirebaseFirestore.instance
                  .collection("images")
                  .where("name", isEqualTo: "travelimage4")
                  .get()
                  .then((res) {
                res.docs.forEach((result) {
                  FirebaseFirestore.instance.getReferenceFromUrl(result.data["url"])
                      .then((res) {
                    res.delete().then((res) {
                      print("Deleted!");
                    });
                  });
                });
              });

            }

          },
          child: SimpleDialogOption(
            child: Text("Delete"),
          ),
        ),
        SizedBox(height: 10,),
        SimpleDialogOption(

          child: Text("Share to"),
        ),
        SizedBox(height: 10,),

        SimpleDialogOption(
          child: Text("Follow"),
        ),
        SizedBox(height: 10,),

        SimpleDialogOption(
          child: Text("Copy link"),
        ),
        SizedBox(height: 30,),


      ],
    );
  }
}

