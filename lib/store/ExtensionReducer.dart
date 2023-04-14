import 'package:scv_app/manager/extensionManager.dart';

ExtensionManager extensionReducer(ExtensionManager state, action) {
  if (action != null && action.runtimeType == ExtensionManager) {
    return action;
  }
  return state;
}
