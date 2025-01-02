import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scv_app/global/global.dart' as global;

class OptionModel {
  const OptionModel(this.value, this.text);
  final int value;
  final String text;

  @override
  String toString() => text;
}

void autoLockPicker(BuildContext context, onConfirm, Biometric biometric) {
  showMaterialScrollPicker(
    context: context,
    title: AppLocalizations.of(global.globalBuildContext)!.pick,
    items: createPickerItems(),
    selectedItem: biometric.autoLockMode,
    onChanged: (value) {
      onConfirm(value);
    },
  );
}

List<OptionModel> createPickerItems() {
  List<OptionModel> items = [];
  Biometric.autoLockModes.forEach((key, value) {
    items.add(OptionModel(key, value));
  });
  return items;
}
