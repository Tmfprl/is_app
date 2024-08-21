import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  // 사용자 로그인 정보 저장
  Future<void> saveUserInfo(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // 사용자 로그인 정보 불러오기
  Future<String?> getUserInfo(String key) async {
    return await _storage.read(key: key);
  }

  // 사용자 로그인 정보 삭제
  Future<void> deleteUserInfo(String key) async {
    await _storage.delete(key: key);
  }
}
