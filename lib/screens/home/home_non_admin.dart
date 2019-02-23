import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/general_provider.dart';

import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/categories_scroller.dart';
import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';
import 'package:cori/screens/product/create_product.dart';
import 'package:cori/screens/product/product_items.dart';

import 'package:cori/screens/home/admin_drawer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.userId});
  final String userId;
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool isLargeScreen;

  VoidCallback listener;

  /*
  String userId;

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(Config.CORI_USER_ID);
    print(userId);
  }
  */

  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    // _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2.7;
    if (size.width > 400.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    final generalItem = GeneralProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Cori",
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProduct()),
          );
          /*
         // _pickImages(5);
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => CreateProduct(),
              ));
              */
        },
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
          elevation: 16.0,
          child: AdminDrawer(size: size, userId: widget.userId)),
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
          StreamBuilder(
              stream: generalItem.api.fetchAllProducts(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(child: LoadingScreen());
                } else if (snapshot.hasData) {
                   return SliverGrid(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (itemWidth / itemHeight),
                        crossAxisCount: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final DocumentSnapshot document =
                            snapshot.data.documents[index];
                         print(document);

                       return ProductItems(
                            isLargeScreen: isLargeScreen, document: document,);


                      }, childCount: snapshot.data.documents.length));
                } else {
                  return SliverToBoxAdapter(
                      child: ErrorScreen(error: snapshot.error.toString()));
                }
              },
            ),


        ],
      ),
    );
  }
}
