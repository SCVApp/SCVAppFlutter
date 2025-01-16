import 'package:flutter/material.dart';

ListTile LockerControllerTile(onTap) {
  return ListTile(
    title: Text('C500 omarice - ime'),
    subtitle: Text('Proste omarice: 5'),
    trailing: Icon(Icons.shelves),
    onTap: onTap,
  );
}
