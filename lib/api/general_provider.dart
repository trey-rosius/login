import 'package:cori/api/firebase_api.dart';
import 'package:cori/api/general_bloc.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends InheritedWidget {
  final GeneralBloc generalBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static GeneralBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(GeneralProvider) as GeneralProvider)
          .generalBloc;

  GeneralProvider({Key key, GeneralBloc itemBloc, Widget child})
      : this.generalBloc = itemBloc ?? GeneralBloc(Api()),
        super(child: child, key: key);
}
