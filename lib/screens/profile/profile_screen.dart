import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/utils/config.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.userId}) : super(key: key);
  final String userId;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Montserrat-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection(Config.CORI_USERS)
                  .document(widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
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
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.cover,
                                        imageUrl: snapshot
                                            .data[Config.CORI_PROFILE_PIC_URL],
                                        placeholder:
                                            new CircularProgressIndicator(),
                                        errorWidget: new Icon(Icons.error),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[Config.CORI_FIRST_NAME] +
                                        " " +
                                        snapshot.data[Config.CORI_LAST_NAME],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Montserrat-Regular',
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[Config.CORI_EMAIL],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.redAccent.shade400,
                                      fontFamily: 'Montserrat-Regular',
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[Config.CORI_PHONE_NUMBER],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat-Regular',
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[Config.CORI_ADDRESS],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, right: 10.0),
                              child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.5),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
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
            ),
          )
        ],
      ),
    );
  }
}
