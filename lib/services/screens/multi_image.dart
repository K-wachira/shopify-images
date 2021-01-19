
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:date_time_format/date_time_format.dart';

class MultiImage extends StatefulWidget {
  String uid;
  MultiImage({Key key, this.uid}) : super(key: key);
  @override
  _MultiImageState createState() => new _MultiImageState();
}


class _MultiImageState extends State<MultiImage> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = List<String>();

  String _error = 'No Error Dectected';
  int length;
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Shopify",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform,
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      length = images.length;
      print(images);
      _error = error;
    });
  }


  void uploadImages(){
    final dateTime = DateTime.now();

    print("uploading mages");
    for ( var imageFile in images) {
      postImage(imageFile).then((downloadUrl) async {
        print(downloadUrl.toString());
        imageUrls.add(downloadUrl.toString());
        if(imageUrls.length==images.length){
          await FirebaseFirestore.instance.collection('Posts').add({
            'Url':imageUrls,
            'UserId' : widget.uid,
            'TimeUploaded': dateTime.format(),
            'UserType': "General",
          }).then((_){
            SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }

  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    var imageUrl = await ( await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    return url;
    //TaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    //print(storageTaskSnapshot.ref.getDownloadURL());
    //return storageTaskSnapshot.ref.getDownloadURL();
  }



  @override
  Widget build(BuildContext context) {
    print(length.toString());
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor("#95BF46"),

          leading: IconButton (
              icon:Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },

          ),

          title: const Text('Pick Images'),
          actions: [
            IconButton(
              icon: Icon(Icons.comment),
              tooltip: 'Icon',
              onPressed: () {
                uploadImages();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Status: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}

