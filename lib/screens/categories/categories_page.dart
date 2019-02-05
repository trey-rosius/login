import 'package:cori/api/general_provider.dart';
import 'package:cori/locale/locale.dart';

import 'package:cori/screens/categories/categories_item.dart';
import 'package:cori/screens/categories/create_category.dart';
import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage(this.userId);
  final String userId;
  bool isLargeScreen = false;

  @override
  Widget build(BuildContext context) {
    final categoriesItem = GeneralProvider.of(context);
    Size size = MediaQuery.of(context).size;
    if (size.width > 400.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          AppLocalizations.of(context).categories,
          style: new TextStyle(
            fontSize: 22.0,
            fontFamily: "Montserrat-Regular",
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        label: Text(AppLocalizations.of(context).create),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateCategory(
                      userId: userId,
                    )),
          );
        },
        icon: Icon(Icons.category),
      ),
      body: StreamBuilder(
        stream: categoriesItem.api.fetchMainCategories(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return CategoriesItem(
                isLargeScreen: isLargeScreen, snapshot: snapshot);
          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
