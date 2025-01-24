import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';

class LockerSlidable extends StatefulWidget {
  final Locker locker;
  final bool isUsers;
  final Function refresh;
  final bool disabled;

  const LockerSlidable({
    Key? key,
    required this.locker,
    required this.isUsers,
    required this.refresh,
    this.disabled = false,
  }) : super(key: key);

  @override
  _LockerSlidableState createState() => _LockerSlidableState();
}

class _LockerSlidableState extends State<LockerSlidable>
    with SingleTickerProviderStateMixin {
  late final SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    slidableController = SlidableController(this); // Provide the Ticker
  }

  @override
  void dispose() {
    slidableController
        .dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  void openSlidable() {
    if (widget.disabled == true) {
      return;
    }
    slidableController.openStartActionPane();
  }

  void openLocker(arg) async {
    final OpenLockerResult result = await widget.locker.openLocker();
    if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: result.success ? Colors.blueGrey : Colors.red,
      ));
    }
    widget.refresh();
  }

  void endLocker(arg) async {
    final EndLockerResult result = await widget.locker.endLocker();
    if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: result.success ? Colors.blueGrey : Colors.red,
      ));
    }
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openSlidable,
      child: _buildSlidable(),
    );
  }

  String statusText() {
    if (widget.isUsers) {
      return "Vaša omarica";
    } else if (widget.locker.used) {
      return "Zasedena";
    } else {
      return "Prosta";
    }
  }

  Icon statusIcon() {
    if (widget.isUsers) {
      return Icon(Icons.person);
    } else if (widget.locker.used) {
      return Icon(Icons.lock);
    } else {
      return Icon(Icons.lock_open);
    }
  }

  Widget _buildSlidable() {
    return Slidable(
      enabled: !widget.disabled,
      controller: this.slidableController,
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          if (widget.isUsers)
            SlidableAction(
              onPressed: endLocker,
              icon: Icons.logout,
              backgroundColor: Colors.red,
              label: "Končaj",
            ),
          if (widget.isUsers)
            SlidableAction(
              onPressed: openLocker,
              icon: Icons.lock_open,
              backgroundColor: Colors.blue,
              label: "Odpri",
            ),
          if (!widget.isUsers)
            SlidableAction(
              onPressed: openLocker,
              icon: Icons.lock,
              backgroundColor: Colors.blue,
              label: "Rezerviraj",
            ),
        ],
      ),
      child: ListTile(
        title: Text(widget.locker.identifier),
        subtitle: Text(statusText()),
        trailing: statusIcon(),
      ),
    );
  }
}
