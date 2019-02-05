import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/create_sub_category.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';

class SubCategoryItem extends StatelessWidget {
  SubCategoryItem(
      {Key key, this.snapshot, this.userId, this.catId, this.catName})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final String userId;
  final String catId;
  final String catName;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final DocumentSnapshot document = snapshot.data.documents[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateSubCategory(
                            title: AppLocalizations.of(context).editSubCategory,
                            userId: userId,
                            catId: catId,
                            catName: catName,
                            subCatId: document[Config.CORI_CATEGORIES_ID],
                          )),
                );
              },
              title: Text(
                document[Config.CORI_CATEGORY_NAME],
                style: new TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Montserrat-Regular",
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.redAccent,
              ),
            )),
          );
        },
        // Or, uncomment the following line:
        childCount: snapshot.data.documents.length,
      ),
    );
  }
}
