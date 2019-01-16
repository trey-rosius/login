import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class Config {
  /**
   * System Constants and Storage bucket
   */

  static final String CORI_STORAGE_BUCKET = "gs://cori-b6795.appspot.com/";
  static final String CORI_CREATE_BY = "createdBy";

  /**
   * User constants
   */
  static final String CORI_USERS = "Users";
  static final String CORI_ADMIN = "admin";
  static final String CORI_ADDRESS = "address";
  static final String CORI_USER_ID = "userId";
  static final String CORI_PROFILE_PIC = "profilePic";
  static final String CORI_PROFILE_PIC_URL = "profilePicUrl";
  static final String CORI_FIRST_NAME = "firstName";
  static final String CORI_LAST_NAME = "lastName";
  static final String CORI_EMAIL = "email";
  static final String CORI_PHONE_NUMBER = "phoneNumber";
  /**
   * Store Constants
   */
  static final String CORI_STORE = "stores";
  static final String CORI_STORE_ID = "storeId";
  static final String CORI_STORE_NAME = "storeName";
  static final String CORI_STORE_DESC = "storeDesc";
  static final String CORI_STORE_ADDRESS = "storeAddress";
  static final String CORI_STORE_PIC = "storePic";
  static final String CORI_STORE_OWNER = "storeOwner";

  /**
   * 
   * Categories and Sub Categories Constants
   */
  static final String CORI_CATEGORIES = "categories";
  static final String CORI_CATEGORIES_ID = "catId";
  static final String CORI_SUB_CATEGORIES_ID = "subCatId";
  static final String CORI_SUB_CATEGORIES = "subCategories";
  static final String CORI_CATEGORY_NAME = "catName";
  static final String CORI_SUB_CATEGORY_NAME = "subCatName";
  static final String CORI_CATEGORY_DESCRIPTION = "catDesc";
  static final String CORI_CATEGORY_IMAGE = "catImage";

/**
 * Firebase Configuration Parameters
 * 
 */
  static Future<FirebaseApp> firebaseConfig() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'cori',
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: '1:598699684568:ios:d5bf2ed5286a127d',
              gcmSenderID: '598699684568',
              apiKey: 'AIzaSyDDvJW_nl6f7YHWVHw0Zb-O6cD3Vd0aP6s',
              projectID: 'cori-b6795',
              bundleID: 'com.leonel.cori')
          : const FirebaseOptions(
              googleAppID: '1:598699684568:android:d5bf2ed5286a127d',
              apiKey: 'AIzaSyDDvJW_nl6f7YHWVHw0Zb-O6cD3Vd0aP6s',
              projectID: 'cori-b6795',
            ),
    );
    return app;
  }
}
