import 'dart:io';

import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  ImageItem({this.imageList, this.onDelete});
  final File imageList;

  VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          Image.file(
            imageList,
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 6,
            child: InkWell(
              onTap: this.onDelete,
              child: Icon(
                Icons.cancel,
                color: Colors.redAccent,
                size: 40.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
