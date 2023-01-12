import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/store/AppState.dart';

Widget AlertContainer() {
  return StoreConnector<AppState, AppState>(
    converter: (store) => store.state,
    builder: (context, state) {
      return state.globalAlert.isShow == true
          ? Container(
              padding: EdgeInsets.all(20),
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      state.globalAlert.text ?? "",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  state.globalAlert.action ?? SizedBox(),
                ],
              ))
          : SizedBox();
    },
  );
}
