import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ListTile LockerControllerTile(BuildContext context, LockerController controller,
    {onTap}) {
  return ListTile(
    title: Text(controller.name),
    subtitle: Text(
        '${AppLocalizations.of(context)!.free_lockers}: ${controller.freeLockers}'),
    trailing: Icon(Icons.shelves),
    onTap: onTap,
  );
}
