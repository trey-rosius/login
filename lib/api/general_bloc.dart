import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/api/firebase_api.dart';

class GeneralBloc {
  Api api;

  Stream<QuerySnapshot> userInfo = Stream.empty();
  Stream<QuerySnapshot> get getUserInfo => userInfo;

  Stream<QuerySnapshot> productItems = Stream.empty();
  Stream<QuerySnapshot> get getProductItems => productItems;

  Stream<QuerySnapshot> storeItems = Stream.empty();
  Stream<QuerySnapshot> get getStoreItems => storeItems;

  GeneralBloc(this.api) {
    userInfo = api.fetchAllCategories();
    productItems = api.fetchAllProducts();
    storeItems = api.fetchAllStores();
  }
}
