import 'package:scv_app/api/user.dart';

User userReducer(User state, action) {
  if (action != null && action.runtimeType == User) {
    return action;
  }
  return state;
}
