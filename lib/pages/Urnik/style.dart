import 'package:scv_app/api/urnik/urnik.dart';

class UrnikStyle {
  static String mainTitle(PoukType type) {
    switch (type) {
      case PoukType.zacetekPouka:
        return "začetek pouka";
      case PoukType.pouk:
        return "naslednje ure";
      case PoukType.odmor:
        return "naslednje ure";
    }
  }
}
