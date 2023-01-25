import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/store/AppState.dart';

class AlertContainer extends StatefulWidget {
  @override
  _AlertContainerState createState() => _AlertContainerState();
}

class _AlertContainerState extends State<AlertContainer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AnimatedAlign(
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            heightFactor: state.globalAlert.isShow ? 1 : 0,
            child: Container(
                padding: EdgeInsets.all(20),
                color: Theme.of(context).scaffoldBackgroundColor,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state.globalAlert.icon != null
                        ? Icon(state.globalAlert.icon)
                        : SizedBox(),
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
                )));
      },
    );
  }
}
