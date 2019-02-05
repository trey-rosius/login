import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CategoriesList extends StatefulWidget {
  CategoriesList({this.snapshot});

  final AsyncSnapshot<QuerySnapshot> snapshot;

  @override
  CategoriesListState createState() {
    return new CategoriesListState();
  }
}

class CategoriesListState extends State<CategoriesList> {
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
    return ListView.builder(
      itemCount: widget.snapshot.data.documents.length,
      itemBuilder: (_, int index) {
        final DocumentSnapshot document = widget.snapshot.data.documents[index];

        return Container(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                print("presses");
              },
              child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(10.0),
                shadowColor: Color(0x802196F3),
                child: Column(
                  children: <Widget>[
                    Container(
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
                  ],
                ),
              ),
            ));
      },
    );
  }
}
