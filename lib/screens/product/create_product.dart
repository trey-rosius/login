import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';
import 'package:cori/screens/product/uploading_images_screen.dart';
import 'package:cori/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
   bool uploading = false;
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

  final productPriceController = TextEditingController();
  void showInSnackBar(String value) {
   _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.redAccent,
    ));
  }
  uploadProductDetails() {
    FormState form = _formKey.currentState;
    if (!form.validate()) {
      autovalidate = true;
      showInSnackBar(AppLocalizations
          .of(context)
          .fixErrors);
    } else {
      setState(() {
        uploading = true;
      });

      var reference = Firestore.instance.collection(Config.CORI_PRODUCTS);

      reference.add({
        Config.CORI_PRODUCT_NAME: productNameController.text,
        Config.CORI_PRODUCT_PRICE: productPriceController.text,
        Config.CORI_PRODUCT_DESC: productDescriptionController.text,
        Config.CORI_PRODUCT_CATEGORY: categoryId,
        Config.CORI_PRODUCT_KEYWORDS: productKeywordsController.text,

        "timestamp": new DateTime.now().toString(),
      }).then((DocumentReference doc) {
        String docId = doc.documentID;
        reference
            .document(docId)
            .updateData({Config.CORI_PRODUCT_ID: docId});

        productNameController.clear();
        productPriceController.clear();
        productDescriptionController.clear();
        categoryController.clear();
        categoryId = "";
        productKeywordsController.clear();
        setState(() {
          uploading = false;

        });



        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadImagesScreen(
                productId: docId,
              )),
        );

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                                          categoryController.text =
                                          document[Config
                                              .CORI_CATEGORY_NAME];
                                          categoryId = document[
                                          Config.CORI_CATEGORIES_ID];
                                          Navigator.of(context).pop();
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


        ],
      ),
      bottomNavigationBar: Container(
        width: width,
        height: height / 8,
        color: Colors.redAccent,
        child: uploading == true
            ? SpinKitWave(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            );
          },
        )
            : MaterialButton(
          onPressed: () {
            uploadProductDetails();

          },
          color: Colors.redAccent,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(

                "Save and Continue",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
