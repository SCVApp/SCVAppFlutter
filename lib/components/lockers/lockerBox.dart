import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';

class LockerBox extends StatefulWidget {
  final Locker locker;
  final bool isUsers;
  final Function refresh;
  final bool disabled;

  const LockerBox({
    Key? key,
    required this.locker,
    required this.isUsers,
    required this.refresh,
    this.disabled = false,
  }) : super(key: key);

  @override
  _LockerBoxState createState() => _LockerBoxState();
}

class _LockerBoxState extends State<LockerBox> {
  bool loading = false;
  OverlayEntry? overlayEntry;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    hideOverlay();
    timer?.cancel();
    super.dispose();
  }

  void openOrEndLocker() async {
    if (widget.disabled == true ||
        (widget.locker.used == true && widget.isUsers == false)) {
      return;
    }
    setState(() {
      loading = true;
    });
    if (widget.isUsers == true) {
      endLocker();
    } else {
      openLocker();
    }
  }

  void openLocker() async {
    final OpenLockerResult result = await widget.locker.openLocker();
    if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: result.success ? Colors.blueGrey : Colors.red,
      ));
    }
    setState(() {
      loading = false;
    });
    widget.refresh();
  }

  void endLocker() async {
    final EndLockerResult result = await widget.locker.endLocker();
    if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: result.success ? Colors.blueGrey : Colors.red,
      ));
    }
    setState(() {
      loading = false;
    });
    widget.refresh();
  }

  void showOverlay(String text) {
    hideOverlay();
    timer?.cancel();
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        right: MediaQuery.of(context).size.width / 2 -
            MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    timer = Timer(Duration(seconds: 2), hideOverlay);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void showInfo() {
    if (widget.locker.used == true && widget.isUsers == false) {
      showOverlay("Ta omarica je zasedena");
    } else if (widget.disabled == true) {
      showOverlay("Ta omarica je onemogočena");
    } else {
      showOverlay("Za odklep klikni in pridrži");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showInfo,
      onLongPress: openOrEndLocker,
      child: _buildBox(),
    );
  }

  Color getBackgroundColor() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isUsers == true) {
      return isDark ? Colors.green.shade300 : Colors.green.shade100;
    } else if (widget.locker.used == true) {
      return isDark ? Colors.red.shade300 : Colors.red.shade100;
    } else if (widget.disabled == true) {
      return isDark ? Colors.grey.shade600 : Colors.grey.shade100;
    }
    return Theme.of(context).cardColor;
  }

  Icon getIcon() {
    if (widget.isUsers == true) {
      return Icon(Icons.person);
    } else if (widget.locker.used == true) {
      return Icon(Icons.lock_outline);
    }
    return Icon(Icons.lock_open);
  }

  Widget _buildBox() {
    return Container(
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(widget.locker.identifier,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    getIcon()
                  ])));
  }
}
