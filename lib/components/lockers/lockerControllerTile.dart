import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/lockerController.dart';

ListTile LockerControllerTile(LockerController controller, {onTap}) {
  return ListTile(
    title: Text(controller.name),
    subtitle: Text('Proste omarice: ${controller.freeLockers}'),
    trailing: Icon(Icons.shelves),
    onTap: onTap,
  );
}
