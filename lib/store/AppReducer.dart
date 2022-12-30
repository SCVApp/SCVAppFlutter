//create appReducer
import 'package:scv_app/store/AppState.dart';

import 'UserReducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    user: userReducer(state.user, action),
  );
}