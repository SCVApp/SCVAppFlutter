import 'package:scv_app/store/AppState.dart';
import 'package:scv_app/store/AppThemeReducer.dart';
import 'package:scv_app/store/BiometricReducer.dart';
import 'package:scv_app/store/ExtensionReducer.dart';
import 'package:scv_app/store/GlobalAlertReducer.dart';
import 'package:scv_app/store/MaliceReducer.dart';
import 'package:scv_app/store/UrnikReducer.dart';
import 'package:scv_app/store/WindowManagerReducer.dart';
import 'UserReducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    user: userReducer(state.user, action),
    appTheme: appThemeReducer(state.appTheme, action),
    biometric: biometricReducer(state.biometric, action),
    urnik: urnikReducer(state.urnik, action),
    globalAlert: globalAlertReducer(state.globalAlert, action),
    windowManager: windowManagerReducer(state.windowManager, action),
    extensionManager: extensionReducer(state.extensionManager, action),
    malica: malicaReducer(state.malica, action),
  );
}
