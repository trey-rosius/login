import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/general_provider.dart';

import 'package:cori/screens/categories/categories_scroller_item.dart';
import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';
import 'package:flutter/cupertino.dart';

class CategoriesScroller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesItem = GeneralProvider.of(context);
    return StreamBuilder(
      stream: categoriesItem.api.fetchMainCategories(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(child: LoadingScreen());
        } else if (snapshot.hasData) {
          return CategoriesScrollerItem(snapshot: snapshot);
        } else {
          return SliverToBoxAdapter(
              child: ErrorScreen(error: snapshot.error.toString()));
        }
      },
    );
  }
}
