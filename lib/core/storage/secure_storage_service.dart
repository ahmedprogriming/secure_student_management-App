import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
 final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  static const _emailKey = 'user_email';

  Future<void> saveToken({required String accessToken, required String refreshToken, String? email}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (email != null) {
      await _storage.write(key: _emailKey, value: email);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }
  Future<void> deleteToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _emailKey);
  }
}