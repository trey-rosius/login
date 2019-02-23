import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/general_provider.dart';
import 'package:cori/screens/categories/error_screen.dart';
import 'package:cori/screens/categories/loading_screen.dart';
import 'package:cori/screens/store/create_store.dart';
import 'package:cori/screens/store/store_item.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Stores extends StatefulWidget {
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {

  String userId;
  String storeType = "Approved";
  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(Config.CORI_USER_ID);
    print(userId);
  }

  void initState() {
    super.initState();
    _getUserId();
  }
  bool isLargeScreen;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2.7;
    if (size.width > 400.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
  //  final generalItem = GeneralProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stores",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Montserrat-Regular',
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.redAccent,
            ),
            child: DropdownButton(
                value: storeType,

                items: <String>[
                  "Approved",
                  "Declined",
                  "Awaiting"
                ].map((String value) {
                  return new DropdownMenuItem(
                      value: value,
                      child: new Text(
                        '${value}',
                        style: TextStyle(fontSize: 18.0,color: Colors.white),
                      ));
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    storeType = value;
                  });
                }),
          ),
        ],
      ),
      body:

          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection(Config.CORI_STORE).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return  LoadingScreen();
              } else if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, int index) {
                          final DocumentSnapshot document =
                          snapshot.data.documents[index];
                          print(document);

                          return StoreItems(
                            isLargeScreen: isLargeScreen, document: document,);


                        });
              } else {
                return ErrorScreen(error: snapshot.error.toString());
              }
            },
          ),



      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => CreateStore(userId),
            ));
      },
      child: Icon(Icons.store,color: Colors.white,),
      ),
    );
  }
}
