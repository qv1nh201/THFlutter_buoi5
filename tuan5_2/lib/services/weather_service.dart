import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Thay thế bằng API Key của bạn từ OpenWeatherMap
  // Nếu chưa có, hãy đăng ký tại https://home.openweathermap.org/users/sign_up
  static const String apiKey = '891e18ef1e731f691030347956fe6866';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// Hàm lấy dữ liệu thời tiết theo tên thành phố
  /// Trả về đối tượng WeatherModel nếu thành công
  /// Ném ra Exception nếu thất bại
  Future<WeatherModel> fetchWeather(String cityName) async {
    // Xây dựng URL với tham số:
    // q: tên thành phố
    // appid: api key
    // units: metric (để lấy độ C)
    // lang: vi (để lấy mô tả tiếng Việt)
    final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric&lang=vi');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Nếu server trả về OK (200), giải mã JSON
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        // Lỗi 404 thường do sai tên thành phố
        throw Exception('Không tìm thấy thành phố này.');
      } else {
        // Các lỗi khác
        throw Exception('Lỗi tải dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      // Bắt lỗi mạng hoặc lỗi hệ thống
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
}