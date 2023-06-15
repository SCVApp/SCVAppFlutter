import 'package:scv_app/api/malice/malicaDan.dart';

import 'malicaUser.dart';

class Malica {
  static final String apiURL = "https://malice.scv.si/api/v2";
  final MalicaUser maliceUser = new MalicaUser();
  final List<MalicaDan> dnevi = [];

  Future<void> loadFirstDays() async {
    final promises = <Future>[];
    for (int i = 0; i < 2; i++) {
      dnevi.add(new MalicaDan(i));
      promises.add(dnevi[i].loadMenus());
    }
    await Future.wait(promises);
  }

  MalicaDan getDay(int id) {
    return dnevi.firstWhere((element) => element.id == id, orElse: () => null);
  }
}
