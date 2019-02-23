import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';
import 'package:cori/api/general_bloc.dart';
import 'package:cori/api/general_provider.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/home/home_non_admin.dart';
import 'package:cori/utils/config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:cori/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

//import 'package:custom_multi_image_picker/asset.dart';
//import 'package:custom_multi_image_picker/custom_multi_image_picker.dart';

class UserInformation extends StatefulWidget {
  UserInformation(this.userId);
  final String userId;
  @override
  UserInformationState createState() {
    return UserInformationState();
  }
}

class UserInformationState extends State<UserInformation> {
  bool loading = false;
  var uuid;
  bool uploading = false;
  File file;

  String _error;
  String profilePic;

  Future<File> _imageFile;

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
        .child(Config.CORI_USERS)
        .child(Config.CORI_PROFILE_PIC)
        .child(widget.userId)
        .child("cori_$uuid.jpg");
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
            firestore.collection(Config.CORI_USERS).document(widget.userId);
        var map = new Map<String, dynamic>();
        map[Config.CORI_FIRST_NAME] = firstNamesController.text;
        map[Config.CORI_LAST_NAME] = lastNamesController.text;
        map[Config.CORI_ADDRESS] = addressController.text;
        map[Config.CORI_PROFILE_PIC_URL] = data;
        map[Config.CORI_PHONE_NUMBER] = phone1Controller.text;

        map['updatedAt'] = new DateTime.now().toString();

        reference.updateData(map).then((_) {
          setState(() {
            _imageFile = null;
            uploading = false;

            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => GeneralProvider(
                        itemBloc: GeneralBloc(Api()),
                        child: HomeScreen(userId: widget.userId,),
                      ),
                ));
            print("user info saved properly");
          });
        });

        // postToFireStore(imageUrl: data, name: myController.text);
      }).then((_) {
        setState(() {
          _imageFile = null;
          uploading = false;
        });
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
          firestore.collection(Config.CORI_USERS).document(widget.userId);
      var map = new Map<String, dynamic>();
      map[Config.CORI_FIRST_NAME] = firstNamesController.text;
      map[Config.CORI_LAST_NAME] = lastNamesController.text;
      map[Config.CORI_ADDRESS] = addressController.text;

      map[Config.CORI_PHONE_NUMBER] = phone1Controller.text;

      map['updatedAt'] = new DateTime.now().toString();

      reference.updateData(map).then((_) {
        setState(() {
          uploading = false;

          print("saved properly");
        });
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => GeneralProvider(
                    itemBloc: GeneralBloc(Api()),
                    child: HomeScreen(userId: widget.userId,),
                  ),
            ));

        // Navigator.of(context).pop();
      });
    });
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            file = snapshot.data;

            return InkWell(
              onTap: () => _onImageButtonPressed(ImageSource.gallery, 3),
              child: new Container(

                  // height: MediaQuery.of(context).size.height/2.5,
                  child: CircleAvatar(
                radius: 70.0,
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
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 70.0,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 80.0,
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
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 70.0,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 80.0,
                  ),
                ),
              ),
            );
          }
        });
  }

  static DateTime dateTime = DateTime.now();
  UserModel uModel = UserModel();

  void showInSnackBar(String value) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.redAccent,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final firstNamesController = TextEditingController();
  final lastNamesController = TextEditingController();
  final addressController = TextEditingController();

  final phone1Controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() {
    Firestore.instance
        .collection(Config.CORI_USERS)
        .document(widget.userId)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        firstNamesController.text = snapshot[Config.CORI_FIRST_NAME];
        lastNamesController.text = snapshot[Config.CORI_LAST_NAME];
        phone1Controller.text = snapshot[Config.CORI_PHONE_NUMBER];
        addressController.text = snapshot[Config.CORI_ADDRESS];
        profilePic = snapshot[Config.CORI_PROFILE_PIC_URL];
      });
    });
  }

  void saveUserInfo() {
    setState(() {
      loading = true;
    });

    if (_imageFile == null) {
      updateWithoutImage();
    } else {
      updateWithImage();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    firstNamesController.dispose();
    lastNamesController.dispose();

    addressController.dispose();
    phone1Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).updateProfile,
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
            InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, 1);
              },
              child: _imageFile == null
                  ? ClipOval(
                      child: profilePic != null
                          ? CachedNetworkImage(
                              width: 110.0,
                              height: 110.0,
                              fit: BoxFit.cover,
                              imageUrl: profilePic,
                              placeholder: (context,url)=>new CircularProgressIndicator(),
                              errorWidget:(context,url,ex)=> new Icon(Icons.error),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              radius: 70.0,
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 80.0,
                              ),
                            ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _previewImage()
                      // child: _prev,
                      ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: TextFormField(
                      controller: firstNamesController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).firstName;
                        }
                      },
                      onSaved: (String firstName) {
                        uModel.firstName = firstName;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).firstName,
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
                      controller: lastNamesController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).lastName;
                        }
                      },
                      onSaved: (String lastName) {
                        uModel.lastName = lastName;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).lastName,
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
                      controller: phone1Controller,
                      keyboardType: TextInputType.number,
                      onSaved: (String tel) {
                        uModel.phoneNumber = tel;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).phoneNumber,
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
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      maxLines: 7,
                      onSaved: (String tel) {
                        uModel.phoneNumber = tel;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).address,
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
        child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              saveUserInfo();
            }
          },
          color: Colors.redAccent,
          child: Padding(
            padding: EdgeInsets.all(24.0),
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
                : Text(AppLocalizations.of(context).saveAndContinue,
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
