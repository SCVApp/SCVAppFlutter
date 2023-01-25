import 'package:flutter/material.dart';

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
        return "Vrata so uspešno odklenjena";
      case ThemeColorForStatus.promisson_denied:
        return "Trenutno nimaš pouka v tej učilnici";
      case ThemeColorForStatus.time_out:
        return "Malo počakaj, da lahko ponovno odkleneš vrata";
      case ThemeColorForStatus.error:
        return "Učilnica ne obstaja";
      case ThemeColorForStatus.lock_status:
        return "Vrata so zaklenjena";
      case ThemeColorForStatus.door_not_opened:
        return "Vrata niso bila odprta";
      case ThemeColorForStatus.unknown:
        return "Neznana napaka";
      default:
        return "Neznana napaka";
    }
  }

  String get infoMessage {
    if (this == ThemeColorForStatus.error) {
      return "Prosim poskusite ponovno";
    } else if (this == ThemeColorForStatus.success) {
      return "";
    } else if (this == ThemeColorForStatus.time_out) {
      return "Presegli ste število odklepanj v določenem času";
    }
    return "Pritisni ključavnico za odklep";
  }
}
