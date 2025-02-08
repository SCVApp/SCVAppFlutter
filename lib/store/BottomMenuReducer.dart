import 'package:scv_app/api/bottomMenu.dart';

BottomMenu bottomMenuReducer(BottomMenu state, action) {
  if (action != null && action.runtimeType == BottomMenu) {
    return action;
  }
  return state;
}
