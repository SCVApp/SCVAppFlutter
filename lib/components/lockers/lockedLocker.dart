import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';

Widget LockedLocker(Locker locker) {
  return Container(
      color: Colors.red.shade100,
      child: ListTile(
        title: Text(locker.identifier),
        trailing: Icon(Icons.lock),
      ));
}
