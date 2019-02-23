import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/product/image_item.dart';
import 'package:cori/screens/product/image_list.dart';
import 'package:cori/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pit_multiple_image_picker/pit_multiple_image_picker.dart';
import 'package:uuid/uuid.dart';
class UploadImagesScreen extends StatefulWidget {
  UploadImagesScreen({this.productId});
  final String productId;
  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  List<File> files;
  String categoryId;
  Future<List<File>> _imageFile;
  List<String>imageListUrls = new List<String>();
  List<File> finalUploadFiles;
  bool uploading = false;
  Future<String> uploadImage(var imageFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();
    StorageReference ref = storage.ref().child(Config.CORI_PRODUCTS).child(widget.productId).child("prod_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;
  }

void uploadProductImages(){
    setState(() {
      uploading = true;
    });

      Config.firebaseConfig().then((FirebaseApp firebaseApp) {
      final FirebaseStorage storage = new FirebaseStorage(
          app: firebaseApp, storageBucket: Config.CORI_STORAGE_BUCKET);

      for (int index = 0; index < finalUploadFiles.length; index++) {
        uploadImage(finalUploadFiles[index], storage).then((String data) {
          print(data);

          imageListUrls.add(data);

        }).then((_){

          if(imageListUrls.length == finalUploadFiles.length){


            var reference = Firestore.instance.collection(Config.CORI_PRODUCTS)
                .document(widget.productId);
            reference.updateData({
              Config.CORI_PRODUCT_MAIN_IMAGE: imageListUrls[0],
              Config.CORI_PRODUCT_IMAGES: imageListUrls
            }).then((_){
              print("upload completed");
              setState(() {
                uploading = false;
              });

              Navigator.of(context).pop();

            });

          }
          else {

          }

          print(imageListUrls.length);
          print(finalUploadFiles.length);
        });


      }

      /*
      if(imageListUrls.length == finalUploadFiles.length){
        setState(() {
          uploading = false;
        });
      }
      else {

      }
      */
    });

}



  Widget _previewImage() {
    return FutureBuilder<List<File>>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            files = snapshot.data;
            finalUploadFiles = files;
            return (files.length == 1)
                ? //for pickImage case (1 image)
            files[0] == null
                ? SliverToBoxAdapter(child: Container())
                : SliverToBoxAdapter(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.file(
                          files[0],
                          width: 200.0,
                          height: 200.0,
                        )),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 3,
                      child: InkWell(
                        onTap:(){
                          setState(() {
                            files[0] =null;
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                          size: 40.0,
                        ),
                      ),
                    )
                  ],
                ))
                :
            ImageList(
               files: files,
               setFiles: (List<File> images){
                 finalUploadFiles = images;
               },

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
  void _pickImages(int maxImages) {
    setState(() {
      _imageFile = PitMultipleImagePicker.pickImages(maxImages: maxImages);
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
          AppLocalizations.of(context).uploadProductImages,
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(),
          ),
          _previewImage(),

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
            if(finalUploadFiles.length > 0)
              {
                uploadProductImages();
              }
            print(finalUploadFiles.toString());


          },
          color: Colors.redAccent,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(

                AppLocalizations.of(context).uploadProductImages,
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

