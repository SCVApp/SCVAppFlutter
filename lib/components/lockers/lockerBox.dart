import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openPopup() {
    if (widget.disabled == true ||
        (widget.locker.used == true && widget.isUsers == false)) {
      return;
    }

    this.displayPopup();
  }

  void openLocker() async {
    final OpenLockerResult result = await widget.locker.openLocker();
    if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: result.success ? Colors.blueGrey : Colors.red,
      ));
    }
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
    widget.refresh();
  }

  void displayPopup() {
    if (widget.isUsers == true) {
      usersDialog();
    } else {
      notUsersDialog();
    }
  }

  void usersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "${AppLocalizations.of(context)!.locker} ${widget.locker.identifier}"),
          content: Text(AppLocalizations.of(context)!.your_locker_is_in_use),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                endLocker();
              },
              child: Text(AppLocalizations.of(context)!.end_locker_use),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openLocker();
                },
                child: Text(AppLocalizations.of(context)!.open_locker)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.nothing),
            ),
          ],
        );
      },
    );
  }

  void notUsersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "${AppLocalizations.of(context)!.locker} ${widget.locker.identifier}"),
          content: Text(AppLocalizations.of(context)!.start_locker_use),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openLocker();
              },
              child: Text(AppLocalizations.of(context)!.reserve_locker),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openPopup,
      child: _buildBox(),
    );
  }

  Color getBackgroundColor() {
    if (widget.isUsers == true) {
      return Colors.green.shade100;
    } else if (widget.locker.used == true) {
      return Colors.red.shade100;
    } else if (widget.disabled == true) {
      return Colors.grey.shade200;
    }
    return Colors.white;
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
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.locker.identifier,
              style: TextStyle(fontWeight: FontWeight.bold)),
          getIcon()
        ])));
  }
}
