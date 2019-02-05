import 'dart:io';

import 'package:cori/screens/product/image_item.dart';
import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  ImageList({this.files});
  final List<File> files;

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<File> imageFiles;
  void initState() {
    super.initState();
    imageFiles = widget.files;
  }

  void removeItem(int index) {
    setState(() {
      print("clicked");

      imageFiles = List.from(imageFiles)..removeAt(index);

      print(imageFiles.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return imageFiles == null
                ? new Container()
                : ImageItem(
                    imageList: imageFiles[index],
                    onDelete: () => removeItem(index));
          },
          childCount: imageFiles.length,
        ));
  }
}
