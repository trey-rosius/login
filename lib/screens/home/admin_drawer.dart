import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';
import 'package:cori/api/general_bloc.dart';
import 'package:cori/api/general_provider.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/categories_page.dart';
import 'package:cori/screens/profile/profile_screen.dart';

import 'package:cori/screens/store/create_store.dart';
import 'package:cori/screens/store/stores.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';


class AdminDrawer extends StatefulWidget {
  AdminDrawer({Key key, this.size,this.userId}) : super(key: key);
  final Size size;
  final String userId;


  @override
  AdminDrawerState createState() {
    return new AdminDrawerState();
  }
}

class AdminDrawerState extends State<AdminDrawer> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Column(
        children: <Widget>[
          Container(
           // color: Colors.white,
            padding: EdgeInsets.only(top: 50.0,left: 10.0),
            child:StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection(Config.CORI_USERS)
                  .document(widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.toString());
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: snapshot.data[
                                Config.CORI_PROFILE_PIC_URL] !=
                                    null
                                    ? CachedNetworkImage(
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot
                                      .data[Config.CORI_PROFILE_PIC_URL],
                                  placeholder:(context,url)=>
                                  new CircularProgressIndicator(),
                                  errorWidget:(context,url,ex)=> new Icon(Icons.error),
                                )
                                    : CircleAvatar(
                                  backgroundColor: Colors.redAccent,
                                  radius: 50.0,
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 70.0,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.data[Config.CORI_FIRST_NAME] +
                                          " " +
                                          snapshot.data[Config.CORI_LAST_NAME],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Montserrat-Regular',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.data[Config.CORI_EMAIL],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat-Regular',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.data[Config.CORI_PHONE_NUMBER],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat-Regular',
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 50.0,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 70.0,
                    ),
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 50.0,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 70.0,
                    ),
                  );
                }
              },
            )
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushNamed('/Genre');
            },
            leading: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text("Home",
                style: TextStyle(
                    fontFamily: "Montserrat-Regular",
                    fontSize: 20.0,
                    color: Colors.white)),
          ),
          Padding(
            padding: EdgeInsets.only(left: widget.size.width / 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(userId: widget.userId),
                  ));
              // Navigator.of(context).pushNamed('/Genre');
            },
            leading: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            title: Text("Profile",
                style: TextStyle(
                    fontFamily: "Montserrat-Regular",
                    fontSize: 20.0,
                    color: Colors.white)),
          ),
          Padding(
            padding: EdgeInsets.only(left: widget.size.width / 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pushNamed('/Genre');
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => GeneralProvider(
                            itemBloc: GeneralBloc(Api()),
                            child: CategoryPage(widget.userId),
                          ),
                    ));
              },
              leading: Icon(
                Icons.category,
                color: Colors.white,
              ),
              title: Text(AppLocalizations.of(context).categories,
                  style: TextStyle(
                      fontFamily: "Montserrat-Regular",
                      fontSize: 20.0,
                      color: Colors.white)),
              trailing: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(Config.CORI_CATEGORIES)
                      .where(Config.CORI_PARENT_CATEGORIES_ID, isNull: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            snapshot.data.documents.length.toString(),
                            style: TextStyle(color: Colors.redAccent),
                          ));
                    } else {
                      return Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            "0",
                            style: TextStyle(color: Colors.redAccent),
                          ));
                    }
                  })),
          Padding(
            padding: EdgeInsets.only(left: widget.size.width / 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pushNamed('/Genre');
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) =>  Stores(),

                    ));

              },
              leading: Icon(
                Icons.store,
                color: Colors.white,
              ),
              title: Text(AppLocalizations.of(context).stores,
                  style: TextStyle(
                      fontFamily: "Montserrat-Regular",
                      fontSize: 20.0,
                      color: Colors.white)),
              trailing: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(Config.CORI_STORE)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            snapshot.data.documents.length.toString(),
                            style: TextStyle(color: Colors.redAccent),
                          ));
                    } else {
                      return Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            "0",
                            style: TextStyle(color: Colors.redAccent),
                          ));
                    }
                  })),
          Padding(
            padding: EdgeInsets.only(left: widget.size.width / 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
