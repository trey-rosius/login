import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';

class GeneralBloc {
  Api api;

  Stream<QuerySnapshot> userInfo = Stream.empty();
  Stream<QuerySnapshot> get getUserInfo => userInfo;

  GeneralBloc(this.api) {
    userInfo = api.fetchAllCategories();
  }
}
