import 'package:flutter/material.dart';

class pop_up_menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text("Go to post"),
          Divider(),
          Text("Save"),
          Divider(),

          Text("share"),
          Divider(),

          Text("Copy Link"),
          Divider(),

          Text("Delete"),
          Divider(),

          Text("Report"),
          Divider(),

          Text("Cancel"),
        ],
      ),
    );
  }
}
