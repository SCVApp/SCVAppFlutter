import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scv_app/global/global.dart';

enum ThemeColorForStatus {
  success,
  promisson_denied,
  error,
  unknown,
  lock_status,
  time_out,
  door_not_opened
}

extension ThemeColorForStatusExtension on ThemeColorForStatus {
  Color get color {
    switch (this) {
      case ThemeColorForStatus.success:
        return Colors.green;
      case ThemeColorForStatus.promisson_denied:
        return Colors.orange;
      case ThemeColorForStatus.time_out:
        return Colors.orange;
      case ThemeColorForStatus.error:
        return Colors.red;
      case ThemeColorForStatus.lock_status:
        return Colors.red;
      case ThemeColorForStatus.door_not_opened:
        return Colors.red;
      case ThemeColorForStatus.unknown:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeColorForStatus.success:
        return Icons.lock_open_outlined;
      case ThemeColorForStatus.promisson_denied:
        return Icons.lock_outline;
      case ThemeColorForStatus.error:
        return Icons.error_outline;
      case ThemeColorForStatus.door_not_opened:
        return Icons.lock_outline;
      case ThemeColorForStatus.unknown:
        return Icons.lock_outline;
      default:
        return Icons.lock_outline;
    }
  }

  String get message {
    switch (this) {
      case ThemeColorForStatus.success:
        return AppLocalizations.of(globalBuildContext)!.door_unlock_success;
      case ThemeColorForStatus.promisson_denied:
        return AppLocalizations.of(globalBuildContext)!.door_no_class_hour;
      case ThemeColorForStatus.time_out:
        return AppLocalizations.of(globalBuildContext)!.door_wait_unlock;
      case ThemeColorForStatus.error:
        return AppLocalizations.of(globalBuildContext)!.door_classroom_nonexistent;
      case ThemeColorForStatus.lock_status:
        return AppLocalizations.of(globalBuildContext)!.door_locked;
      case ThemeColorForStatus.door_not_opened:
        return AppLocalizations.of(globalBuildContext)!.door_unlock_unsuccessful;
      case ThemeColorForStatus.unknown:
        return AppLocalizations.of(globalBuildContext)!.unknown_error;
      default:
        return AppLocalizations.of(globalBuildContext)!.unknown_error;
    }
  }

  String get infoMessage {
    if (this == ThemeColorForStatus.error) {
      return AppLocalizations.of(globalBuildContext)!.try_again;
    } else if (this == ThemeColorForStatus.success) {
      return "";
    } else if (this == ThemeColorForStatus.time_out) {
      return AppLocalizations.of(globalBuildContext)!.door_unlock_limit_reached;
    }
    return AppLocalizations.of(globalBuildContext)!.door_press_lock;
  }
}
