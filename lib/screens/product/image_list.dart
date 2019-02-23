import 'dart:io';

import 'package:cori/screens/product/image_item.dart';
import 'package:flutter/material.dart';
typedef ListCallback = void Function(List<File> listImages);
class ImageList extends StatefulWidget {
  ImageList({this.files,this.setFiles});
  final List<File> files;
  final ListCallback setFiles;


  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<File> imageFiles;

  void initState() {
    super.initState();
    imageFiles = widget.files;
    print("bunch of files"+imageFiles.toString());
  }

  void removeItem(int index) {
    setState(() {
      print("clicked");

      imageFiles = List.from(imageFiles)..removeAt(index);

      widget.setFiles(imageFiles);

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
                      ),





    );

  }
}
