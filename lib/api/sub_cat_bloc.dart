import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';

class SubCatBloc {
  Api api;

  Stream<QuerySnapshot> subCatItems = Stream.empty();
  Stream<QuerySnapshot> get getSubCatItems => subCatItems;

  SubCatBloc(this.api, String categoryId) {
    subCatItems = api.fetchSubCategories(categoryId);
  }
}
