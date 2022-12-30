import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  String accessToken;
  String refreshToken;
  String expiresOn;
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Token(
      {this.accessToken = "", this.refreshToken = "", this.expiresOn = null}) {
    if (accessToken == "" && refreshToken == "" && expiresOn == null) {
      loadToken();
    }
  }

  String accessTokenKey = "SCVApp-key-access-token";
  String refreshTokenKey = "SCVApp-key-refresh-token";
  String expiresKey = "SCVApp-key-expires-on";

  Future<void> saveToken() async {
    await storage.write(key: accessTokenKey, value: accessToken);
    await storage.write(key: refreshTokenKey, value: refreshToken);
    await storage.write(key: expiresKey, value: expiresOn.toString());
  }

  Future<void> loadToken() async {
    try {
      accessToken = await storage.read(key: accessTokenKey);
      refreshToken = await storage.read(key: refreshTokenKey);
      expiresOn = await storage.read(key: expiresKey);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteToken() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
    await storage.delete(key: expiresKey);
  }
}
