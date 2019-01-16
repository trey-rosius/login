import 'dart:io';

import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/categories_scroller.dart';
import 'package:cori/utils/config.dart';
import 'package:pit_multiple_image_picker/pit_multiple_image_picker.dart';
import 'package:cori/screens/home/admin_drawer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  Future<List<File>> _imageFile;

  VoidCallback listener;
  /*
  String userId;

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(Config.CORI_USER_ID);
    print(userId);
  }
  */

  void _pickImages(int maxImages) {
    setState(() {
      _imageFile = PitMultipleImagePicker.pickImages(maxImages: maxImages);
    });
  }

  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    // _getUserId();
  }

  Widget _previewImage() {
    return FutureBuilder<List<File>>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            List<File> files = snapshot.data;
            return (files.length == 1)
                ? //for pickImage case (1 image)
                files[0] == null
                    ? SliverToBoxAdapter(child: Container())
                    : new SliverToBoxAdapter(
                        child: Image.file(files[0]),
                      )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Image.file(files[index]);
                    },
                    childCount: files.length,
                  ));
          } else if (snapshot.error != null) {
            return SliverToBoxAdapter(
              child: const Text(
                'Error picking image.',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return SliverToBoxAdapter(
              child: const Text(
                'You have not yet picked an image.',
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Shopaholic",
          style: TextStyle(
              fontFamily: "Montserrat-Regular",
              fontSize: 22.0,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w800),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.search),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.shopping_cart),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickImages(5);
        },
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
      ),
      drawer: Drawer(elevation: 16.0, child: AdminDrawer(size: size)),
      body: CustomScrollView(
        slivers: <Widget>[
          /*
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
              child: Text(
                "Advertisements",
                style: new TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Montserrat-Regular",
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          */

          SliverToBoxAdapter(
              child: SizedBox(
            height: size.height / 3,
            width: size.width,
            child: Carousel(
              images: [
                ExactAssetImage(
                  'assets/images/airforce.jpeg',
                ),
                ExactAssetImage(
                  'assets/images/vans.jpeg',
                ),
                ExactAssetImage(
                  'assets/images/airmax.jpeg',
                ),
                ExactAssetImage(
                  'assets/images/nike.jpeg',
                ),
              ],
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotColor: Colors.white,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.transparent,
              // borderRadius: true,
            ),
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.redAccent,
                    height: 20.0,
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      AppLocalizations.of(context).categories,
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat-Regular",
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CategoriesScroller(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.purple.withOpacity(0.5),
                    height: 20.0,
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Home",
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat-Regular",
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Image.asset(
              "assets/images/airmax.jpeg",
              height: size.height / 3,
              width: size.width,
              fit: BoxFit.cover,
            ),
          )),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              "assets/images/vans.jpeg",
              height: size.height / 3,
              width: size.width,
              fit: BoxFit.cover,
            ),
          )),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              "assets/images/nike.jpeg",
              height: size.height / 3,
              width: size.width,
              fit: BoxFit.cover,
            ),
          )),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              "assets/images/airforce.jpeg",
              height: size.height / 3,
              width: size.width,
              fit: BoxFit.cover,
            ),
          )),
          _previewImage()
        ],
      ),
    );
  }
}
