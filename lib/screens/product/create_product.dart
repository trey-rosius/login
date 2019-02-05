import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/locale/locale.dart';

import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';

import 'package:cori/screens/product/image_list.dart';

import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:pit_multiple_image_picker/pit_multiple_image_picker.dart';

class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productKeywordsController = TextEditingController();
  final categoryController = TextEditingController();
  String filter;
  List<String> items;
  List<File> files;
  String categoryId;
  Future<List<File>> _imageFile;
  final productPriceController = TextEditingController();
  void _pickImages(int maxImages) {
    setState(() {
      _imageFile = PitMultipleImagePicker.pickImages(maxImages: maxImages);
    });
  }

  Widget _previewImage() {
    return FutureBuilder<List<File>>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            files = snapshot.data;
            return (files.length == 1)
                ? //for pickImage case (1 image)
                files[0] == null
                    ? SliverToBoxAdapter(child: Container())
                    : SliverToBoxAdapter(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.file(
                              files[0],
                            )))
                : ImageList(
                    files: files,
                  );
          } else if (snapshot.error != null) {
            return SliverToBoxAdapter(
                child: Text(
              'Error picking image.',
              textAlign: TextAlign.center,
            ));
          } else {
            return SliverToBoxAdapter(
                child: Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            ));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).createProduct,
          style: new TextStyle(
            fontSize: 22.0,
            fontFamily: "Montserrat-Regular",
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              _pickImages(5);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add_a_photo),
            ),
          )
        ],
      ),
      drawer: Drawer(
          child: Stack(children: <Widget>[
        Flex(direction: Axis.vertical, children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 34.0, 16.0, 10.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Category..',
              ),
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.redAccent,
                fontFamily: "Montserrat-Regular",
                decoration: TextDecoration.none,
              ),
              onChanged: (String value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.redAccent.withOpacity(0.8),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(Config.CORI_CATEGORIES)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingScreen();
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, int index) {
                        final DocumentSnapshot document =
                            snapshot.data.documents[index];
                        //items.add(snapshot.data.documents[index].documentID);
                        return filter == null || filter == ""
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 5.0, left: 5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print("presses");
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: new Text(
                                            document[Config.CORI_CATEGORY_NAME],
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontFamily: "Montserrat-Regular",
                                            ),
                                          ),
                                        ),
                                      )),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              )
                            : document[Config.CORI_CATEGORY_NAME]
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(
                                              top: 5.0, left: 5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                categoryController.text =
                                                    document[Config
                                                        .CORI_CATEGORY_NAME];
                                                categoryId = document[
                                                    Config.CORI_CATEGORIES_ID];
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: new Text(
                                                document[
                                                    Config.CORI_CATEGORY_NAME],
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      "Montserrat-Regular",
                                                ),
                                              ),
                                            ),
                                          )),
                                      Divider(
                                        color: Colors.white,
                                      )
                                    ],
                                  )
                                : new Container();
                      },
                    );
                  } else {
                    return ErrorScreen(error: snapshot.error.toString());
                  }
                },
              ),
            ),
          )
        ]),
      ])),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Form(
                    autovalidate: autovalidate,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: new TextFormField(
                            controller: productNameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context).productName;
                              }
                            },
                            decoration: new InputDecoration(
                                labelText:
                                    AppLocalizations.of(context).productName,
                                contentPadding: new EdgeInsets.all(12.0),
                                filled: true,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      width: 2.0, color: Colors.white),
                                )),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: new TextFormField(
                            controller: productDescriptionController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context).productDesc;
                              }
                            },
                            maxLines: 7,
                            decoration: new InputDecoration(
                                labelText:
                                    AppLocalizations.of(context).productDesc,
                                contentPadding: new EdgeInsets.all(12.0),
                                filled: true,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      width: 2.0, color: Colors.white),
                                )),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: new TextFormField(
                            controller: productPriceController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .productPrice;
                              }
                            },
                            decoration: new InputDecoration(
                                labelText:
                                    AppLocalizations.of(context).productPrice,
                                contentPadding: new EdgeInsets.all(12.0),
                                filled: true,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      width: 2.0, color: Colors.white),
                                )),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: new TextFormField(
                            controller: productKeywordsController,
                            maxLines: 3,
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .productKeywords;
                              }
                            },
                            decoration: new InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .productKeywords,
                                contentPadding: new EdgeInsets.all(12.0),
                                filled: true,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      width: 2.0, color: Colors.white),
                                )),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: InkWell(
                            onTap: () {
                              _scaffoldkey.currentState.openDrawer();
                            },
                            child: new TextFormField(
                              controller: categoryController,
                              enabled: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context).selectCat;
                                }
                              },
                              decoration: new InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context).selectCat,
                                  contentPadding: new EdgeInsets.all(12.0),
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 2.0, color: Colors.white),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              "Select Product Images",
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: "Montserrat-Regular",
              ),
            ),
          ),
          _previewImage()
        ],
      ),
    );
  }
}
