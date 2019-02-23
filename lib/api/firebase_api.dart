import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/utils/config.dart';

class Api {
  Stream<QuerySnapshot> fetchMainCategories() {
    return Firestore.instance
        .collection(Config.CORI_CATEGORIES)
        .where(Config.CORI_PARENT_CATEGORIES_ID, isNull: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchAllProducts() {
    return Firestore.instance.collection(Config.CORI_PRODUCTS).snapshots();
  }
  Stream<QuerySnapshot> fetchAllStores() {
    return Firestore.instance.collection(Config.CORI_STORE).snapshots();
  }

  Stream<QuerySnapshot> fetchAllCategories() {
    return Firestore.instance.collection(Config.CORI_CATEGORIES).snapshots();
  }

  Stream<QuerySnapshot> fetchSubCategories(String categoryId) {
    return Firestore.instance
        .collection(Config.CORI_CATEGORIES)
        .where(Config.CORI_PARENT_CATEGORIES_ID, isEqualTo: categoryId)
        .snapshots();
  }
}
