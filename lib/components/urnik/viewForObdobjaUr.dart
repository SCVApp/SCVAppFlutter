import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/components/urnik/viewForObdobjeUre.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';

class ViewForObdobjaUr extends StatefulWidget {
  final double gap;

  ViewForObdobjaUr({Key key, this.gap}) : super(key: key);

  @override
  _viewForObdobjaUrState createState() => _viewForObdobjaUrState();
}

class _viewForObdobjaUrState extends State<ViewForObdobjaUr> {
  GlobalKey listKey = GlobalKey();

  double spaceAtTheEnd = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => addSpace());
  }

  Future<void> handleRefresh() async {
    Urnik urnik = StoreProvider.of<AppState>(context).state.urnik;
    await urnik.refresh(forceFetch: true);
    StoreProvider.of<AppState>(context).dispatch(urnik);
  }

  void addSpace() {
    if (listKey == null || listKey.currentContext == null) {
      return;
    }
    try {
      double height =
          listKey.currentContext.findRenderObject().paintBounds.height;
      if (height != null) {
        setState(() {
          spaceAtTheEnd = max(height - UrnikStyle.viewStyleSmall.height, 100);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Urnik>(
        converter: (store) => store.state.urnik,
        builder: (context, urnik) {
          return Expanded(
              child: RefreshIndicator(
            child: ListView.builder(
              key: listKey,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == urnik.obdobjaUr.length) {
                  if (urnik.poukType == PoukType.konecPouka ||
                      urnik.obdobjaUr.length == 0) {
                    return Container();
                  }
                  return Container(
                    height: spaceAtTheEnd,
                  );
                }
                return Padding(
                  child: ViewForObdobjeUre(
                      obdobjeUr: urnik.obdobjaUr[index],
                      viewSizes: UrnikStyle.viewStyleSmall),
                  padding: EdgeInsets.only(bottom: widget.gap),
                );
              },
              itemCount: urnik.obdobjaUr.length + 1,
            ),
            onRefresh: handleRefresh,
          ));
        });
  }
}
