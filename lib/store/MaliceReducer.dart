import 'package:scv_app/api/malice/malica.dart';

Malica malicaReducer(Malica state, action) {
  if (action != null && action.runtimeType == Malica) {
    return action;
  }
  return state;
}
