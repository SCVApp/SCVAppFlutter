import 'package:flutter/cupertino.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LockerErrors {
  static const String lockerNotFound = "Locker not found";
  static const String notUsingLocker = "User is not using this locker";
  static const String lockerInUse = "This locker is already in use";
  static const String lockerLimitReached =
      "You have reached the limit of lockers";
  static const String failedToOpenLocker = "Failed to open locker";

  static String getErrorMessage(String error) {
    BuildContext context = global.globalBuildContext;

    AppLocalizations localizations = AppLocalizations.of(context)!;

    switch (error) {
      case lockerNotFound:
        return localizations.locker_not_found;
      case notUsingLocker:
        return localizations.not_using_locker;
      case lockerInUse:
        return localizations.locker_in_use;
      case lockerLimitReached:
        return localizations.locker_limit_reached;
      case failedToOpenLocker:
        return localizations.failed_to_open_locker;
      default:
        return localizations.unknown_error;
    }
  }
}
