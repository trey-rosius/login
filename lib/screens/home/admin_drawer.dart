import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';
import 'package:cori/api/general_bloc.dart';
import 'package:cori/api/general_provider.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/categories/categories_page.dart';
import 'package:cori/screens/profile/profile_screen.dart';
import 'package:cori/screens/profile/user_information.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDrawer extends StatefulWidget {
  AdminDrawer({Key key, this.size}) : super(key: key);
  final Size size;

  @override
  AdminDrawerState createState() {
    return new AdminDrawerState();
  }
}

class AdminDrawerState extends State<AdminDrawer> {
  String userId;
  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(Config.CORI_USER_ID);
    print("user" + userId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: widget.size.height / 4,
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
                    builder: (context) => new ProfileScreen(userId: userId),
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
                            child: CategoryPage(),
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
                      builder: (context) => GeneralProvider(
                            itemBloc: GeneralBloc(Api()),
                            child: CategoryPage(),
                          ),
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
