import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/sub_cat_provider.dart';

import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/create_category.dart';
import 'package:cori/screens/categories/create_sub_category.dart';
import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';
import 'package:cori/screens/categories/sub_category_item.dart';
import 'package:cori/utils/config.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum OptionsCat { Edit, Delete }

class ViewCategory extends StatelessWidget {
  ViewCategory(
      {this.userId, this.catId, this.catName, this.catImage, this.catDesc});

  final String userId;
  final String catId;
  final String catName;
  final String catImage;
  final String catDesc;

  @override
  Widget build(BuildContext context) {
    final subCatItem = SubCatProvider.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateSubCategory(
                        userId: userId,
                        catId: catId,
                        catName: catName,
                      )),
            );
          },
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.add),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            /*
          iconTheme: IconThemeData(
            color: Colors.redAccent, //change your color here
          ),
          */
            title: Text(
              catName,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat-Regular",
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<OptionsCat>(
                onSelected: (OptionsCat result) {
                  if (result.index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateCategory(
                                title: AppLocalizations.of(context)
                                    .editStoreCategory,
                                userId: userId,
                                catId: catId,
                              )),
                    );
                  } else {}
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<OptionsCat>>[
                      const PopupMenuItem<OptionsCat>(
                        value: OptionsCat.Edit,
                        child: Text("Edit Category"),
                      ),
                      const PopupMenuItem<OptionsCat>(
                        value: OptionsCat.Delete,
                        child: Text("Delete Category"),
                      ),
                    ],
              )
            ],
            backgroundColor: Colors.redAccent.shade100,
            expandedHeight: size.height / 2.5,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: size.height / 2.5,
                width: size.width,
                child: Hero(
                  tag: catId,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: catImage,
                    placeholder: new CircularProgressIndicator(),
                    errorWidget: new Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Card(
              color: Colors.redAccent.shade100,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      catName,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Montserrat-Regular",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      catDesc,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "Montserrat-Regular",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).subCategory,
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat-Regular",
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection(Config.CORI_CATEGORIES)
                            .where(Config.CORI_PARENT_CATEGORIES_ID,
                                isEqualTo: catId)
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
                                  snapshot.data.documents.length.toString(),
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
                Divider()
              ],
            ),
          ),
          StreamBuilder(
              stream: subCatItem.api.fetchSubCategories(catId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: LoadingScreen(),
                  );
                } else if (snapshot.hasData) {
                  return SubCategoryItem(
                    snapshot: snapshot,
                    userId: userId,
                    catId: catId,
                    catName: catName,
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: ErrorScreen(
                      error: snapshot.error.toString(),
                    ),
                  );
                }
              }),
        ]));
  }
}
