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

class ProductItems extends StatelessWidget {
  ProductItems({this.isLargeScreen, this.document});

  final bool isLargeScreen;
  final DocumentSnapshot document;



  @override
  Widget build(BuildContext context) {


        return Container(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                /*
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
                */
              },
              child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Hero(
                          tag: new Random.secure(),
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                          child:
                          AspectRatio(
                            aspectRatio: 18.0 / 20.0,
                          child:CachedNetworkImage(
                            width: 200.0,

                              fit: BoxFit.cover,
                              imageUrl: document[Config.CORI_PRODUCT_MAIN_IMAGE],
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
                          )
                        ),
                        ),
                         Container(
                            color: Colors.redAccent,
                            padding: const EdgeInsets.all(2.0),
                            child: new Text(
                              document[Config.CORI_PRODUCT_PRICE] +" FCFA",
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontFamily: "Montserrat-Regular",
                              ),
                            ),

                        ),
                      ],
                    ),

                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: new Text(
                                  document[Config.CORI_PRODUCT_NAME],
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Montserrat-Regular",
                                  ),
                                ),
                          ),
                            ),







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
            );



  }
}
