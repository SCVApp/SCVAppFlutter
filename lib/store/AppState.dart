//create class AppState

import 'package:meta/meta.dart';
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/api/user.dart';

class AppState {
  final User user;
  final AppTheme appTheme;

  AppState({
    @required this.user,
    @required this.appTheme,
  });

  factory AppState.initial() {
    return AppState(
      user: new User(),
      appTheme: new AppTheme(),
    );
  }
}
