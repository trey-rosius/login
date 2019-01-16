import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/utils/config.dart';

class Api {
  Stream<QuerySnapshot> fetchAllCategories() {
    return Firestore.instance.collection(Config.CORI_CATEGORIES).snapshots();
  }

  Stream<QuerySnapshot> fetchSubCategories(String categoryId) {
    return Firestore.instance
        .collection(Config.CORI_SUB_CATEGORIES)
        .where(Config.CORI_CATEGORIES_ID, isEqualTo: categoryId)
        .snapshots();
  }
}
