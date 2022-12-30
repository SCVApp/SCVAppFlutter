//create class AppState

import 'package:meta/meta.dart';
import 'package:scv_app/api/user.dart';

class AppState {
  final User user;

  AppState({
    @required this.user,
  });

  factory AppState.initial() {
    return AppState(
      user: new User(),
    );
  }
}
