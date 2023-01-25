import 'package:scv_app/api/appTheme.dart';

AppTheme appThemeReducer(AppTheme state, action) {
  if (action != null && action.runtimeType == AppTheme) {
    return action;
  }
  return state;
}
