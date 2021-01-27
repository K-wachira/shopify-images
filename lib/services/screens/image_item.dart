import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// This class is shows the image in details when clicked on

class ImageItem extends StatefulWidget {
  final String image;

  ImageItem({Key key, this.image, }) : super(key: key);
  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  double imageheight;
  var sizes;
  bool loading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  Gets an instance of firestore
  var dbconn = FirebaseFirestore.instance;

  Future<Size> _calculateImageDimension() async {
    Completer<Size> completer = Completer();
    Image image = await Image.network(widget.image);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  void getHeight() async {
    await _calculateImageDimension().then((size) {
      setState(() {
        sizes = size;
        print(size);
        var abc = sizes.toString();
        var newString = abc.substring(abc.length - 6, (abc.length - 1));
        imageheight = double.parse(newString);
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print(imageheight);
    print("Imageheight");
  }

  void _AddComment() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 50,
            child: Container(
              child: _buildBottomCommentSection(),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
            ),
          );
        });
  }

  // this widget shows the comment section

  Row _buildBottomCommentSection() {
    return Row(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            icon: Icon(Icons.comment),
            hintText: 'Write your comment here',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        GestureDetector(
          child: Icon(
            Icons.send,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: HeroHeader(
              minExtent: 250,
              maxExtent: 800,
              image: widget.image,
            ),
          ),
        ],
      ),
    );
  }

}

// TODO classic how classes work
// deals with displaying the image on the sliver bar and expanding/shrinking it appropriately
class HeroHeader implements SliverPersistentHeaderDelegate {
  HeroHeader({
    this.minExtent,
    this.maxExtent,
    this.image,
    this.imagetag,
  });
  String image;
  double maxExtent;
  double minExtent;
  String imagetag;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          placeholder: (context, url) =>
              Image.asset('assets/images/loading.gif'),
          placeholderFadeInDuration: Duration(milliseconds: 300),
          imageUrl: image,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 4.0,
          top: 4.0,
          child: SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            imagetag,
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => throw UnimplementedError();

  @override
  // TODO: implement vsync
  TickerProvider get vsync => throw UnimplementedError();
}
