import 'package:scv_app/api/alert.dart';

GlobalAlert globalAlertReducer(GlobalAlert state, action) {
  if (action != null && action.runtimeType == GlobalAlert) {
    return action;
  }
  return state;
}
