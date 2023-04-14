import 'package:scv_app/api/epas/EPAS.dart';

EPASApi epasReducer(EPASApi state, action) {
  if (action != null && action.runtimeType == EPASApi) {
    return action;
  }
  return state;
}
