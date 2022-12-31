//create appReducer
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:scv_app/store/AppThemeReducer.dart';
import 'package:scv_app/store/BiometricReducer.dart';

import 'UserReducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    user: userReducer(state.user, action),
    appTheme: appThemeReducer(state.appTheme, action),
    biometric: biometricReducer(state.biometric, action),
  );
}
