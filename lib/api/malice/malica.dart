import 'malicaUser.dart';

class Malica {
  static final String apiURL = "https://malice.scv.si/api/v2";
  final MalicaUser maliceUser = new MalicaUser();

  String? _afterLoginURL;
  get afterLoginURL => _afterLoginURL;

  setAfterLoginURL(String url) {
    _afterLoginURL = url;
  }

  resetAfterLoginURL() {
    _afterLoginURL = null;
  }
}
