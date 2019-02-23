import 'dart:async';

import 'package:cori/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appName {
    return Intl.message(
      'Cori',
      name: 'appName',
      desc: 'Title for the ecommerce application',
    );
  }

  String get gLogin {
    return Intl.message(
      'Log In With Google',
      name: 'gLogin',
      desc: 'google login',
    );
  }

  String get fLogin {
    return Intl.message(
      'Log In With Facebook',
      name: 'fLogin',
      desc: 'facebook login',
    );
  }

  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: 'loading',
    );
  }

  String get enterEmail {
    return Intl.message(
      'Please Enter Email',
      name: 'enterEmail',
      desc: 'Email Required',
    );
  }

  String get enterPassword {
    return Intl.message(
      'Please Enter Password',
      name: 'enterPassword',
      desc: 'Password Required',
    );
  }

  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: 'Email Required',
    );
  }

  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password Required',
    );
  }

  String get forgotPassword {
    return Intl.message(
      'Forgot Password ?',
      name: 'forgotPassword',
      desc: 'When User Forgets their Password',
    );
  }

  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: 'Sign In User with email and password',
    );
  }

  String get createAccount {
    return Intl.message(
      'Create New Account',
      name: 'createAccount',
      desc: 'Create new Account',
    );
  }

  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: 'Register',
    );
  }

  String get already {
    return Intl.message(
      'Already Have An Account ?',
      name: 'already',
      desc: 'When the user already has an account',
    );
  }

  String get login {
    return Intl.message(
      'Log In',
      name: 'login',
      desc: 'Go to Log In Screen',
    );
  }

  String get errorOccured {
    return Intl.message(
      'An Error Occured, Please Try Again Later',
      name: 'errorOccured',
      desc: 'Go to Log In Screen',
    );
  }

  String get emailExist {
    return Intl.message(
      'Another User Already has this email.',
      name: 'emailExist',
      desc: 'When Email Address Already Exists in Database',
    );
  }

  String get fixErrors {
    return Intl.message(
      'Please resolve these issues',
      name: 'fixErrors',
      desc: 'when user has an issue with the form',
    );
  }

  String get somethingWrong {
    return Intl.message(
      'Something Went Wrong,Please Try Again Later',
      name: 'somethingWrong',
      desc: 'when an error occurs',
    );
  }

  String get acountNonExist {
    return Intl.message(
      'This Account Doesn\'t Exist, Please Create Account',
      name: 'acountNonExist',
      desc: 'This Account Doesn\'t Exist, Please Create Account',
    );
  }

  String get updateProfile {
    return Intl.message(
      'Update Your Profile',
      name: 'updateProfile',
      desc: 'Update Your Profile',
    );
  }

  String get firstName {
    return Intl.message(
      'Enter First Name',
      name: 'firstName',
      desc: 'Enter First Name',
    );
  }

  String get lastName {
    return Intl.message(
      'Enter Last Name',
      name: 'lastName',
      desc: 'Enter Last Name',
    );
  }

  String get phoneNumber {
    return Intl.message(
      'Enter Phone Number',
      name: 'phoneNumber',
      desc: 'Enter Phone Number',
    );
  }

  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: 'Address of User',
    );
  }

  String get saveAndContinue {
    return Intl.message(
      'Save And Continue',
      name: 'saveAndContinue',
      desc: 'Save And Continue',
    );
  }

  String get storeImage {
    return Intl.message(
      'Please Attach A store Image',
      name: 'storeImage',
      desc: 'Please Attach a store Image',
    );
  }

  String get createStore {
    return Intl.message(
      'Create Your Store',
      name: 'createStore',
      desc: 'Create Your Store',
    );
  }

  String get storeName {
    return Intl.message(
      'Store Name',
      name: 'storeName',
      desc: 'Store Name',
    );
  }

  String get storeDesc {
    return Intl.message(
      'Store Description',
      name: 'storeDesc',
      desc: 'Store Description',
    );
  }

  String get storeAddress {
    return Intl.message(
      'Store Address',
      name: 'storeAddress',
      desc: 'Store Address',
    );
  }

  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: 'Categories',
    );
  }

  String get createStoreCat {
    return Intl.message(
      'Create Store Category',
      name: 'createStoreCat',
      desc: 'Create Store Category',
    );
  }

  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: 'create',
    );
  }

  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: 'categoryName',
    );
  }

  String get stores {
    return Intl.message(
      'Stores',
      name: 'stores',
      desc: 'Stores',
    );
  }

  String get categoryDesc {
    return Intl.message(
      'Category Description',
      name: 'categoryDesc',
      desc: 'categoryDesc',
    );
  }

  String get createCategory {
    return Intl.message(
      'Create Category',
      name: 'createCategory',
      desc: 'createCategory',
    );
  }

  String get editCategory {
    return Intl.message(
      'Edit Category',
      name: 'editCategory',
      desc: 'editCategory',
    );
  }

  String get categoryImage {
    return Intl.message(
      'Please Attach a Category Picture',
      name: 'categoryImage',
      desc: 'categoryImage',
    );
  }

  String get createSubCategory {
    return Intl.message(
      'Create Sub Category',
      name: 'categorySubCategory',
      desc: 'Create Sub Category',
    );
  }

  String get subCategoryName {
    return Intl.message(
      'Sub Category Name',
      name: 'subCategoryName',
      desc: 'subCategoryName',
    );
  }

  String get parentCategory {
    return Intl.message(
      'Parent Category',
      name: 'parentCategory',
      desc: 'parentCategory',
    );
  }

  String get subCategory {
    return Intl.message(
      'Sub Categories',
      name: 'subCategory',
      desc: 'subCategory',
    );
  }

  String get editStoreCategory {
    return Intl.message(
      'Edit Store Categories',
      name: 'editStoreCategory',
      desc: 'Edit Store Category',
    );
  }

  String get editSubCategory {
    return Intl.message(
      'Edit Sub Categories',
      name: 'editSubCategory',
      desc: 'Edit Sub Category',
    );
  }

  String get createProduct {
    return Intl.message(
      'Create Product',
      name: 'createProduct',
      desc: 'Create Product',
    );
  }

  String get addProduct {
    return Intl.message(
      'Add Product',
      name: 'addProduct',
      desc: 'Add Product',
    );
  }

  String get invalidEmail {
    return Intl.message("Invalid email address",
        name: 'invalidEmail', desc: 'Invalid Email');
  }

  String get productName {
    return Intl.message("Product Name",
        name: 'productName', desc: 'Product Name');
  }

  String get productDesc {
    return Intl.message("Product Description",
        name: 'productDesc', desc: 'Product Description');
  }

  String get productPrice {
    return Intl.message("Product Price(Frs)",
        name: 'productPrice', desc: 'Product Price');
  }

  String get productKeywords {
    return Intl.message("Product KeyWords",
        name: 'productKeywords', desc: 'Product Keywords');
  }

  String get selectCat {
    return Intl.message("Select Product Category",
        name: 'selectCat', desc: 'Select Product Category');
  }
  String get uploadProductImages {
    return Intl.message("Upload Product Images",
        name: 'uploadProductImages', desc: 'Upload Product Images');
  }
}

// This file was generated in two steps, using the Dart in tl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
