import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';
import 'package:cori/api/sub_cat_bloc.dart';
import 'package:cori/api/sub_cat_provider.dart';
import 'package:cori/screens/categories/view_category.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesScrollerItem extends StatefulWidget {
  CategoriesScrollerItem({Key key, this.snapshot}) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;

  @override
  CategoriesScrollerItemState createState() {
    return new CategoriesScrollerItemState();
  }
}

class CategoriesScrollerItemState extends State<CategoriesScrollerItem> {
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
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
        child: Container(
      height: size.height / 5,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.snapshot.data.documents.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot document =
                widget.snapshot.data.documents[index];

            return Container(
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
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
                                  catImage:
                                      document[Config.CORI_CATEGORY_IMAGE],
                                  catName: document[Config.CORI_CATEGORY_NAME],
                                  catDesc: document[
                                      Config.CORI_CATEGORY_DESCRIPTION],
                                ),
                              )),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 80.0,
                          width: 80.0,
                          imageUrl: document[Config.CORI_CATEGORY_IMAGE],
                          placeholder:(context,url)=> new CircularProgressIndicator(),
                          errorWidget:(context,url,ex)=> new Icon(Icons.error),
                        ),
                      ),
                      Flexible(
                          child: Container(
                        width: size.width / 4,
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                            document[Config.CORI_CATEGORY_NAME],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ));
          }),
    ));
  }
}
