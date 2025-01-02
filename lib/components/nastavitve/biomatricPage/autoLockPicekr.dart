import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scv_app/global/global.dart';

void autoLockPicker(BuildContext context, onConfirm, Biometric biometric) {
  Picker picker = new Picker(
    confirmText: AppLocalizations.of(globalBuildContext)!.pick,
    cancelText: AppLocalizations.of(globalBuildContext)!.cancel,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
