abstract class Extension {
  String name;
  bool enabled = true;
  bool authorised = false;

  void checkAuth() async {}
}
