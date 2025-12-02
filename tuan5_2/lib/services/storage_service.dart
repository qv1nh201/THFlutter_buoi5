import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _lastCityKey = 'last_city_searched';

  /// Lưu tên thành phố vào bộ nhớ máy
  Future<void> saveLastCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCityKey, cityName);
  }

  /// Lấy tên thành phố đã lưu trước đó
  /// Trả về null nếu chưa lưu gì cả
  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCityKey);
  }
}