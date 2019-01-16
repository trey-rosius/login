import 'package:cori/api/firebase_api.dart';

import 'package:cori/api/sub_cat_bloc.dart';
import 'package:flutter/material.dart';

class SubCatProvider extends InheritedWidget {
  final SubCatBloc subCatBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SubCatBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SubCatProvider) as SubCatProvider)
          .subCatBloc;

  SubCatProvider({Key key, SubCatBloc itemBloc, Widget child, String catId})
      : this.subCatBloc = itemBloc ?? SubCatBloc(Api(), catId),
        super(child: child, key: key);
}
