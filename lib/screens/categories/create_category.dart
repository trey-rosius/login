import 'dart:async';

import 'package:cori/locale/locale.dart';
import 'package:cori/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:uuid/uuid.dart';

import 'dart:io';

class CreateCategory extends StatefulWidget {
  CreateCategory({this.title, this.userId, this.catId});
  final String catId;
  final String userId;
  final String title;
  @override
  CreateCategoryState createState() {
    return new CreateCategoryState();
  }
}

class CreateCategoryState extends State<CreateCategory> {
  File file;
  Future<File> _imageFile;
  String profilePic;
  final _formKey = GlobalKey<FormState>();
  final catNameController = TextEditingController();
  final catDescController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool uploading = false;
  bool autovalidate = false;
  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.redAccent,
    ));
  }

  Future<String> uploadImage(var imageFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();
    StorageReference ref = storage.ref().child("cat_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;
  }

  void loadCategoryInfo() {
    Firestore.instance
        .collection(Config.CORI_CATEGORIES)
        .document(widget.catId)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        catNameController.text = snapshot[Config.CORI_CATEGORY_NAME];
        catDescController.text = snapshot[Config.CORI_CATEGORY_DESCRIPTION];

        profilePic = snapshot[Config.CORI_CATEGORY_IMAGE];
      });
    });
  }

  void initState() {
    super.initState();
    loadCategoryInfo();
  }

  void updateCategory() {
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
      Future<FirebaseApp> fApp =
          Config.firebaseConfig().then((FirebaseApp firebaseApp) {
        final FirebaseStorage storage = new FirebaseStorage(
            app: firebaseApp, storageBucket: Config.CORI_STORAGE_BUCKET);
        final Firestore firestore = new Firestore(app: firebaseApp);
        // compressImage();
        Future<String> upload = uploadImage(file, storage).then((String data) {
          var reference = firestore
              .collection(Config.CORI_CATEGORIES)
              .document(widget.catId);

          var map = new Map<String, dynamic>();
          map[Config.CORI_CATEGORY_NAME] = catNameController.text;
          map[Config.CORI_CREATE_BY] = widget.userId;
          map[Config.CORI_CATEGORY_IMAGE] = data;
          map[Config.CORI_PARENT_CATEGORIES_ID] = null;
          map[Config.CORI_CATEGORY_DESCRIPTION] = catDescController.text;
          map["timestamp"] = new DateTime.now().toString();
          reference.updateData(map).then((_) {
            setState(() {
              file = null;
              uploading = false;
              Navigator.of(context).pop();
            });
          });

          // postToFireStore(imageUrl: data, name: myController.text);
        }).then((_) {
          setState(() {
            file = null;
            uploading = false;
          });
        });
      });
    }
  }

  void updateCategoryWithoutImage() {
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
      Future<FirebaseApp> fApp =
          Config.firebaseConfig().then((FirebaseApp firebaseApp) {
        final Firestore firestore = new Firestore(app: firebaseApp);
        // compressImage();

        var reference =
            firestore.collection(Config.CORI_CATEGORIES).document(widget.catId);

        var map = new Map<String, dynamic>();
        map[Config.CORI_CATEGORY_NAME] = catNameController.text;
        map[Config.CORI_CREATE_BY] = widget.userId;
        map[Config.CORI_PARENT_CATEGORIES_ID] = null;
        map[Config.CORI_CATEGORY_DESCRIPTION] = catDescController.text;
        map["timestamp"] = new DateTime.now().toString();
        reference.updateData(map).then((_) {
          setState(() {
            file = null;
            uploading = false;
            Navigator.of(context).pop();
          });
        });
      });
    }
  }

  void saveNewCategory() {
    FormState form = _formKey.currentState;
    if (!form.validate()) {
      autovalidate = true;
      showInSnackBar(AppLocalizations.of(context).fixErrors);
    } else {
      setState(() {
        uploading = true;
      });
      Future<FirebaseApp> fApp =
          Config.firebaseConfig().then((FirebaseApp firebaseApp) {
        final FirebaseStorage storage = new FirebaseStorage(
            app: firebaseApp, storageBucket: Config.CORI_STORAGE_BUCKET);
        final Firestore firestore = new Firestore(app: firebaseApp);

        Future<String> upload = uploadImage(file, storage).then((String data) {
          var reference = firestore.collection(Config.CORI_CATEGORIES);

          reference.add({
            Config.CORI_CATEGORY_NAME: catNameController.text,
            Config.CORI_CATEGORY_DESCRIPTION: catDescController.text,
            Config.CORI_CATEGORY_IMAGE: data,
            Config.CORI_PARENT_CATEGORIES_ID: null,
            Config.CORI_CREATE_BY: widget.userId,
            "timestamp": new DateTime.now().toString(),
          }).then((DocumentReference doc) {
            String docId = doc.documentID;
            reference
                .document(docId)
                .updateData({Config.CORI_CATEGORIES_ID: docId});
            Navigator.of(context).pop();
          });

          // postToFireStore(imageUrl: data, name: myController.text);
        }).then((_) {
          setState(() {
            file = null;
            uploading = false;
          });
        });
      });
    }
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            //  compressImage(snapshot.data);
            file = snapshot.data;
            return InkWell(
              onTap: () => _onImageButtonPressed(ImageSource.gallery),
              child: new CircleAvatar(
                radius: 60.0,
                backgroundImage: FileImage(snapshot.data),
              ),
            );
          } else if (snapshot.error != null) {
            return CircleAvatar(
              radius: 60.0,
              child: Icon(
                Icons.category,
                size: 50.0,
                color: Colors.white,
              ),
              backgroundColor: Colors.redAccent,
            );
          } else {
            return CircleAvatar(
              radius: 60.0,
              child: Icon(
                Icons.category,
                size: 50.0,
                color: Colors.white,
              ),
              backgroundColor: Colors.redAccent,
            );
          }
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    catNameController.dispose();
    catDescController.dispose();

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
              ? AppLocalizations.of(context).createStoreCat
              : AppLocalizations.of(context).editStoreCategory,
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
          children: <Widget>[
            new Column(
              children: <Widget>[
                InkWell(
                    onTap: () => _onImageButtonPressed(ImageSource.gallery),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _imageFile == null
                          ? ClipOval(
                              child: profilePic != null
                                  ? FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: profilePic,
                                      fit: BoxFit.cover,
                                      width: 100.0,
                                      height: 100.0,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.redAccent,
                                      radius: 60.0,
                                      child: Icon(
                                        Icons.store,
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                                    ),
                            )
                          : _previewImage(),
                    )),
                new Form(
                  autovalidate: autovalidate,
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: new TextFormField(
                          controller: catNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).categoryName;
                            }
                          },
                          decoration: new InputDecoration(
                              labelText:
                                  AppLocalizations.of(context).categoryName,
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
                          controller: catDescController,
                          maxLines: 5,
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).categoryDesc;
                            }
                          },
                          decoration: new InputDecoration(
                              labelText:
                                  AppLocalizations.of(context).categoryDesc,
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
                  if (_imageFile == null && profilePic == null) {
                    showInSnackBar(AppLocalizations.of(context).categoryImage);
                  } else if (_imageFile != null && profilePic == null) {
                    saveNewCategory();
                  } else if (_imageFile == null && profilePic != null) {
                    updateCategoryWithoutImage();
                  } else {
                    updateCategory();
                  }
                },
                color: Colors.redAccent,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                      widget.title == null
                          ? AppLocalizations.of(context).createCategory
                          : AppLocalizations.of(context).editCategory,
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
