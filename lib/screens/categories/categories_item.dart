import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';
import 'package:cori/api/sub_cat_bloc.dart';
import 'package:cori/api/sub_cat_provider.dart';
import 'package:cori/screens/categories/view_category.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesItem extends StatefulWidget {
  CategoriesItem({this.isLargeScreen, this.snapshot});

  final bool isLargeScreen;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  var rn = new Random.secure();
  @override
  CategoriesItemState createState() {
    return new CategoriesItemState();
  }
}

class CategoriesItemState extends State<CategoriesItem> {
  String userId;
  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(Config.CORI_USER_ID);
    print(userId);
  }

  void initState() {
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2.2;
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (itemWidth / itemHeight), crossAxisCount: 2),
      itemCount: widget.snapshot.data.documents.length,
      itemBuilder: (_, int index) {
        final DocumentSnapshot document = widget.snapshot.data.documents[index];

        return Container(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCatProvider(
                            itemBloc: SubCatBloc(
                                Api(), document[Config.CORI_CATEGORIES_ID]),
                            child: ViewCategory(
                              userId: userId,
                              catId: document[Config.CORI_CATEGORIES_ID],
                              catImage: document[Config.CORI_CATEGORY_IMAGE],
                              catName: document[Config.CORI_CATEGORY_NAME],
                              catDesc:
                                  document[Config.CORI_CATEGORY_DESCRIPTION],
                            ),
                          )),
                );
              },
              child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(10.0),
                shadowColor: Color(0x802196F3),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: new Random.secure(),
                      child: AspectRatio(
                        aspectRatio: 18.0 / 11.0,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: document[Config.CORI_CATEGORY_IMAGE],
                          placeholder:(context,url)=> SpinKitWave(
                            itemBuilder: (_, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                ),
                              );
                            },
                          ),
                          errorWidget:(context,url,ex)=> new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: size.width / 3,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: new Text(
                            document[Config.CORI_CATEGORY_NAME],
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat-Regular",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5.0, left: 5.0, right: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: size.width / 3,
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: new Text(
                                  Config.CORI_SUB_CATEGORIES,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat-Regular",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection(Config.CORI_CATEGORIES)
                                  .where(Config.CORI_PARENT_CATEGORIES_ID,
                                      isEqualTo:
                                          document[Config.CORI_CATEGORIES_ID])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        snapshot.data.documents.length
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ));
                                } else {
                                  return Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        "0",
                                        style: TextStyle(color: Colors.white),
                                      ));
                                }
                              })
                        ],
                      ),
                    )
                    /*
                    new Text(
                      document[Config.CORI_CATEGORY_DESCRIPTION],
                      style: new TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Montserrat-Regular",
                      ),
                    )
                    */
                  ],
                ),
              ),
            ));
      },
    );
  }
}
