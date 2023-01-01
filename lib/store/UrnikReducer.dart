import 'package:scv_app/api/urnik/urnik.dart';

Urnik urnikReducer(Urnik state, action) {
  if (action != null && action.runtimeType == Urnik) {
    return action;
  }
  return state;
}
