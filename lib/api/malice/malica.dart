import 'malicaUser.dart';

class Malica {
  static final String apiURL = "https://malice.scv.si/api/v2";
  final MalicaUser maliceUser = new MalicaUser();

  String? _afterLoginURL = "https://malice.scv.si/?date=8-3-2024";
  get afterLoginURL => _afterLoginURL;

  setAfterLoginURL(String url) {
    _afterLoginURL = url;
  }

  resetAfterLoginURL() {
    _afterLoginURL = null;
  }
}
