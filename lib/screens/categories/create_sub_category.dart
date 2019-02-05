import 'package:cori/locale/locale.dart';
import 'package:cori/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateSubCategory extends StatefulWidget {
  CreateSubCategory(
      {this.title, this.userId, this.catId, this.catName, this.subCatId});
  final String catId;
  final String subCatId;
  final String userId;
  final String catName;
  final String title;
  @override
  CreateSubCategoryState createState() {
    return new CreateSubCategoryState();
  }
}

class CreateSubCategoryState extends State<CreateSubCategory> {
  final _formKey = GlobalKey<FormState>();
  final subCatNameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool uploading = false;
  bool autovalidate = false;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.redAccent,
    ));
  }

  void loadSubCategoryInfo() {
    Firestore.instance
        .collection(Config.CORI_CATEGORIES)
        .document(widget.subCatId)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        subCatNameController.text = snapshot[Config.CORI_CATEGORY_NAME];
      });
    });
  }

  void initState() {
    super.initState();
    loadSubCategoryInfo();
  }

  void updateSubCategory() {
    FormState form = _formKey.currentState;
    if (!form.validate()) {
      autovalidate = true;
      showInSnackBar(AppLocalizations.of(context).fixErrors);
      setState(() {
        uploading = false;
      });
    } else {
      setState(() {
        uploading = true;
      });

      Config.firebaseConfig().then((FirebaseApp firebaseApp) {
        final Firestore firestore = new Firestore(app: firebaseApp);
        // compressImage();

        var reference = firestore
            .collection(Config.CORI_CATEGORIES)
            .document(widget.subCatId);

        var map = new Map<String, dynamic>();
        map[Config.CORI_CATEGORY_NAME] = subCatNameController.text;
        map[Config.CORI_CREATE_BY] = widget.userId;
        map[Config.CORI_PARENT_CATEGORIES_ID] = widget.catId;

        map["timestamp"] = new DateTime.now().toString();
        reference.updateData(map).then((_) {
          setState(() {
            uploading = false;
            subCatNameController.clear();
          });
        });
      });
    }
  }

  void saveNewSubCategory() {
    FormState form = _formKey.currentState;
    if (!form.validate()) {
      autovalidate = true;
      showInSnackBar(AppLocalizations.of(context).fixErrors);
    } else {
      setState(() {
        uploading = true;
      });

      //  showInSnackBar(subCatNameController.text);

      Config.firebaseConfig().then((FirebaseApp firebaseApp) {
        final Firestore firestore = new Firestore(app: firebaseApp);

        var reference = firestore.collection(Config.CORI_CATEGORIES);

        reference.add({
          Config.CORI_CATEGORY_NAME: subCatNameController.text,
          Config.CORI_PARENT_CATEGORIES_ID: widget.catId,
          Config.CORI_CREATE_BY: widget.userId,
          "timestamp": new DateTime.now().toString(),
        }).then((DocumentReference doc) {
          String docId = doc.documentID;
          reference
              .document(docId)
              .updateData({Config.CORI_CATEGORIES_ID: docId});
        });

        // postToFireStore(imageUrl: data, name: myController.text);
      }).then((_) {
        setState(() {
          uploading = false;
          subCatNameController.clear();
        });
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    subCatNameController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.title == null
              ? AppLocalizations.of(context).createSubCategory
              : AppLocalizations.of(context).editSubCategory,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Montserrat-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context).parentCategory + " :",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.redAccent,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.catName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Montserrat-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Column(
              children: <Widget>[
                new Form(
                  autovalidate: autovalidate,
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: new TextFormField(
                          controller: subCatNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .subCategoryName;
                            }
                          },
                          decoration: new InputDecoration(
                              labelText:
                                  AppLocalizations.of(context).subCategoryName,
                              contentPadding: new EdgeInsets.all(12.0),
                              filled: true,
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    width: 2.0, color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
                  if (widget.subCatId == null) {
                    saveNewSubCategory();
                  } else {
                    updateSubCategory();
                  }
                },
                color: Colors.redAccent,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                      widget.title == null
                          ? AppLocalizations.of(context).createSubCategory
                          : AppLocalizations.of(context).editSubCategory,
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
