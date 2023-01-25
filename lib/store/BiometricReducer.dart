import 'package:scv_app/api/biometric.dart';

Biometric biometricReducer(Biometric state, action) {
  if (action != null && action.runtimeType == Biometric) {
    return action;
  }
  return state;
}
