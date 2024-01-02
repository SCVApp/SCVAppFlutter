//create class AppState

import 'package:scv_app/api/alert.dart';
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/api/malice/malica.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/manager/extensionManager.dart';

class AppState {
  final User user;
  final AppTheme appTheme;
  final Biometric biometric;
  final Urnik urnik;
  final GlobalAlert globalAlert;
  final WindowManager windowManager;
  final ExtensionManager extensionManager;
  final Malica malica;

  AppState({
    required this.user,
    required this.appTheme,
    required this.biometric,
    required this.urnik,
    required this.globalAlert,
    required this.windowManager,
    required this.extensionManager,
    required this.malica,
  });

  factory AppState.initial() {
    return AppState(
      user: new User(),
      appTheme: new AppTheme(),
      biometric: new Biometric(),
      urnik: new Urnik(),
      globalAlert: new GlobalAlert(),
      windowManager: new WindowManager(),
      extensionManager: new ExtensionManager(),
      malica: new Malica(),
    );
  }
}
