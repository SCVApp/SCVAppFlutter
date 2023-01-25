import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/global/global.dart' as global;

void autoLockPicker(BuildContext context, onConfirm, Biometric biometric) {
  Picker picker = new Picker(
    confirmText: "Izberi",
    cancelText: "Prekliči",
    backgroundColor: Theme.of(context).backgroundColor,
    adapter: PickerDataAdapter(data: createPickerItems()),
    onConfirm: onConfirm,
    selecteds: [biometric.autoLockMode],
  );
  picker.showModal(context);
}

List<PickerItem> createPickerItems() {
  List<PickerItem> items = [];
  Biometric.autoLockModes.forEach((key, value) {
    items.add(PickerItem(text: Text(value), value: key));
  });
  return items;
}
