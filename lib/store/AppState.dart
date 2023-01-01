//create class AppState

import 'package:meta/meta.dart';
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/api/user.dart';

class AppState {
  final User user;
  final AppTheme appTheme;
  final Biometric biometric;
  final Urnik urnik;

  AppState({
    @required this.user,
    @required this.appTheme,
    @required this.biometric,
    @required this.urnik,
  });

  factory AppState.initial() {
    return AppState(
      user: new User(),
      appTheme: new AppTheme(),
      biometric: new Biometric(),
      urnik: new Urnik(),
    );
  }
}
