abstract class Extension {
  String name = "";
  bool enabled = true;
  bool authorised = false;

  Future<void> checkAuth() async {}
}
