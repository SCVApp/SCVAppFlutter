import 'package:scv_app/api/windowManager/windowManager.dart';

WindowManager windowManagerReducer(WindowManager state, action) {
  if (action != null && action.runtimeType == WindowManager) {
    return action;
  }
  return state;
}
