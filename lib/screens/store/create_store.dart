import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/components/input_field.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/models/store_model.dart';
import 'package:cori/theme/style.dart';
import 'package:cori/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';

class CreateStore extends StatefulWidget {
  CreateStore(this.userId, {this.storeId});
  final String userId;
  final String storeId;
  @override
  CreateStoreState createState() {
    return CreateStoreState();
  }
}

class CreateStoreState extends State<CreateStore> {
  bool loading = false;
  var uuid;
  bool uploading = false;
  File file;

  String _error;
  String profilePic;

  Future<File> _imageFile;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _onImageButtonPressed(ImageSource source, int numberOfItems) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

/**
 * upload Profile Pic
 */
  Future<String> uploadImage(var imageFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();
    StorageReference ref = storage
        .ref()
        .child(Config.CORI_STORE)
        .child(widget.userId)
        .child("store_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;
  }

  void updateWithImage() {
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
        var reference =
            firestore.collection(Config.CORI_STORE).document(widget.storeId);
        var map = new Map<String, dynamic>();
        map[Config.CORI_STORE_NAME] = storeController.text;
        map[Config.CORI_STORE_DESC] = storeDescriptionController.text;
        map[Config.CORI_STORE_ADDRESS] = storeAddressController.text;
        map[Config.CORI_STORE_OWNER] = widget.userId;
        map[Config.CORI_STORE_PIC] = data;
        map['timestamp'] = new DateTime.now().toString();

        reference.updateData(map).then((_) {
          setState(() {
            uploading = false;
            print("Store Information updated Properly");
          });

          Navigator.of(context).pop();
        });

        // postToFireStore(imageUrl: data, name: myController.text);
      }).then((_) {
        setState(() {
          _imageFile = null;
          uploading = false;

          print("Store Information updated Properly");
        });
        Navigator.of(context).pop();
      });
    });
  }

  void uploadWithImage() {
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
        var reference = firestore.collection(Config.CORI_STORE);
        var map = new Map<String, dynamic>();
        map[Config.CORI_STORE_NAME] = storeController.text;
        map[Config.CORI_STORE_DESC] = storeDescriptionController.text;
        map[Config.CORI_STORE_ADDRESS] = storeAddressController.text;
        map[Config.CORI_STORE_OWNER] = widget.userId;
        map[Config.CORI_STORE_PIC] = data;
        map['timestamp'] = new DateTime.now().toString();

        reference.add(map).then((DocumentReference doc) {
          String docId = doc.documentID;
          reference.document(docId).updateData({Config.CORI_STORE_ID: docId});
        });

        // postToFireStore(imageUrl: data, name: myController.text);
      }).then((_) {
        setState(() {
          _imageFile = null;
          uploading = false;

          print("Store Information updated Properly");
        });
        Navigator.of(context).pop();
      });
    });
  }

  void updateWithoutImage() {
    setState(() {
      uploading = true;
    });

    Future<FirebaseApp> fApp =
        Config.firebaseConfig().then((FirebaseApp firebaseApp) {
      final FirebaseStorage storage = new FirebaseStorage(
          app: firebaseApp, storageBucket: Config.CORI_STORAGE_BUCKET);
      final Firestore firestore = new Firestore(app: firebaseApp);

      var reference =
          firestore.collection(Config.CORI_STORE).document(widget.storeId);
      var map = new Map<String, dynamic>();
      map[Config.CORI_STORE_NAME] = storeController.text;
      map[Config.CORI_STORE_DESC] = storeDescriptionController.text;
      map[Config.CORI_STORE_ADDRESS] = storeAddressController.text;
      map[Config.CORI_STORE_OWNER] = widget.userId;

      map['updatedAt'] = new DateTime.now().toString();

      reference.updateData(map).then((_) {
        setState(() {
          uploading = false;
          print("Store Information updated Properly");
        });

        Navigator.of(context).pop();
      });

      // compressImage();
    });
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            //  compressImage(snapshot.data);
            file = snapshot.data;
            // print(snapshot.data);
            return InkWell(
              onTap: () => _onImageButtonPressed(ImageSource.gallery, 3),
              child: new Container(

                  // height: MediaQuery.of(context).size.height/2.5,
                  child: CircleAvatar(
                radius: 40.0,
                backgroundImage: FileImage(snapshot.data),
              )),
            );
          } else if (snapshot.error != null) {
            // showInSnackBar("Error Picking Image");
            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, 1);
              },
              child: Container(
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 40.0,
                  child: Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            );
          } else {
            // showInSnackBar("You have not yet picked an image.");
            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, 1);
              },
              child: Container(
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 40.0,
                  child: Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            );
          }
        });
  }

  static DateTime dateTime = DateTime.now();
  StoreModel sModel = StoreModel();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.redAccent,
    ));
  }

  final _formKey = GlobalKey<FormState>();

  final storeController = TextEditingController();
  final storeDescriptionController = TextEditingController();
  final storeAddressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStoreInfo();
  }

  void loadStoreInfo() {
    Firestore.instance
        .collection(Config.CORI_STORE)
        .document(widget.storeId)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        storeController.text = snapshot[Config.CORI_STORE_NAME];
        storeDescriptionController.text = snapshot[Config.CORI_STORE_DESC];

        storeAddressController.text = snapshot[Config.CORI_STORE_ADDRESS];
        profilePic = snapshot[Config.CORI_STORE_PIC];
      });
    });
  }

  void saveUserInfo() {
    setState(() {
      loading = true;
    });

    if (_imageFile == null && profilePic == null) {
      showInSnackBar(AppLocalizations.of(context).storeImage);
    } else if (_imageFile == null && profilePic != null) {
      updateWithoutImage();
    } else if (_imageFile != null && profilePic == null) {
      uploadWithImage();
    } else {
      updateWithImage();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    storeController.dispose();
    storeDescriptionController.dispose();

    storeAddressController.dispose();

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
          AppLocalizations.of(context).createStore,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Montserrat-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: InkWell(
                            onTap: () {
                              _onImageButtonPressed(ImageSource.gallery, 1);
                            },
                            child: _imageFile == null
                                ? ClipOval(
                                    child: profilePic != null
                                        ? FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: profilePic,
                                            fit: BoxFit.cover,
                                            width: 60.0,
                                            height: 60.0,
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.redAccent,
                                            radius: 40.0,
                                            child: Icon(
                                              Icons.store,
                                              color: Colors.white,
                                              size: 40.0,
                                            ),
                                          ),
                                  )
                                : _previewImage()
                            // child: _prev,

                            ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: InputField(
                              controller: storeController,
                              hintText: AppLocalizations.of(context).storeName,
                              obscureText: false,
                              textInputType: TextInputType.emailAddress,
                              textStyle: loginFormTextStyle,
                              icon: Icons.store,
                              iconColor: Theme.of(context).primaryColor,
                              bottomMargin: 20.0,
                              onSaved: (String storeName) {
                                sModel.storeName = storeName;
                              }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: TextFormField(
                      controller: storeDescriptionController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).storeDesc;
                        }
                      },
                      onSaved: (String desc) {
                        sModel.storeDesc = desc;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).storeDesc,
                          contentPadding: EdgeInsets.all(12.0),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.white),
                          )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: TextFormField(
                      controller: storeAddressController,
                      keyboardType: TextInputType.text,
                      maxLines: 7,
                      onSaved: (String storeAddress) {
                        sModel.storeAddress = storeAddress;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).storeAddress,
                          contentPadding: EdgeInsets.all(12.0),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        width: width,
        height: height / 8,
        color: Colors.redAccent,
        child: loading == true
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
                  if (_formKey.currentState.validate()) {
                    saveUserInfo();
                  }
                },
                color: Colors.redAccent,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(AppLocalizations.of(context).createStore,
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
