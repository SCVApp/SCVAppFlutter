//create appReducer
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:scv_app/store/AppThemeReducer.dart';

import 'UserReducer.dart';

AppState appReducer(AppState state, action) {
  User userAction;
  if (action.runtimeType == User) {
    userAction = action;
  }
  AppTheme appThemeAction;
  if (action.runtimeType == AppTheme) {
    appThemeAction = action;
  }
  return AppState(
    user: userReducer(state.user, userAction),
    appTheme: appThemeReducer(state.appTheme, appThemeAction),
  );
}
